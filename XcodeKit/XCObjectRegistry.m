/*
 * The sources in the "XcodeKit" directory are based on the Ruby project Xcoder.
 *
 * Copyright (c) 2012 cisimple
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "XCObjectRegistry.h"
#import "XCResource.h"
#import "XCProject.h"
@interface XCObjectRegistry ()
{
    XCProject *_project;
}
@end

NSString * const XCInvalidProjectFileException = @"XCInvalidProjectFileException";

@implementation XCObjectRegistry

@synthesize filePath=_filePath;

#pragma mark Constructors
+ (XCObjectRegistry *)objectRegistryWithXcodeProject:(NSString *)filePath {
    XCObjectRegistry *registry = [[XCObjectRegistry alloc] initWithXcodeProject:filePath];
    return registry;
}

+ (XCObjectRegistry *)objectRegistryForEmptyProjectWithName:(NSString *)projectName {
    XCObjectRegistry *registry = [[[self class] alloc] init];
    
    XCGroup *mainGroup = [XCGroup createLogicalGroupWithName:projectName inRegistry:registry];
    XCProject *project = [XCProject createProjectWithMainGroup:mainGroup inRegistry:registry];
    [registry setResourceObject:mainGroup];
    [registry setResourceObject:project];
    
    registry.project = project;
    return registry;
}

#pragma mark initilizers
- (id)init {
    self = [super init];
    if (self) {
        _filePath=nil;
        NSDictionary *initialPlist = @{ @"formatVersion": @"1", @"classes": [NSDictionary dictionary],
                                        @"objectVersion": @"46", @"objects": [NSMutableDictionary dictionary] };
        _projectPropertyList = [initialPlist mutableCopy];
    }
    return self;
}

- (id)initWithXcodeProject:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath=[filePath stringByAppendingPathComponent:@"/project.pbxproj"];
        NSFileManager *manger=[NSFileManager defaultManager];
        if (![manger fileExistsAtPath:_filePath]) {
            [NSException raise:XCInvalidProjectFileException format:@"project not exists or invalid"];
        }
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_filePath];
        _projectPropertyList = [dict mutableCopy];
    }
    return self;
}

#pragma mark Properties' setters/getters
- (NSInteger)objectVersion {
    return [self.projectPropertyList[@"objectVersion"] integerValue];
}

- (void)setObjectVersion:(NSInteger)archiveVersion {
    self.projectPropertyList[@"objectVersion"] = @(archiveVersion);
}

- (XCProject *)project {
    if (_project==nil) {
        _project=[self objectOfClass:[XCProject class] withKey:self.projectPropertyList[@"rootObject"]];
    }
    return _project;
}
- (void)setProject:(XCProject *)project {
    _project=project;
    [self setResourceObject:project];    // save or not save project?
    self.projectPropertyList[@"rootObject"] = project.identifier.key;
}
- (NSMutableDictionary *)objectDictionary {
    return self.projectPropertyList[@"objects"];
}

#pragma mark create object
- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier {
    XCResource *resource = [[XCResource alloc] initWithIdentifier:identifier registry:self];
    return resource;
}

- (id)objectOfClass:(Class)cls withKey:(NSString *)key {
    NSAssert([cls isSubclassOfClass:[XCResource class]], @"Class %@ must inherit from XCResource", NSStringFromClass(cls));
    XCObjectIdentifier *ident=[[XCObjectIdentifier alloc] initWithKey:key];
    return [[cls alloc] initWithIdentifier:ident registry:self];
}
- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties {
    NSAssert([cls isSubclassOfClass:[XCResource class]], @"Class %@ must inherit from XCResource", NSStringFromClass(cls));
    
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithExistingKeys:self.objectDictionary.allKeys];
    self.objectDictionary[identifier.key] = properties;
    return [[cls alloc] initWithIdentifier:identifier registry:self];
}

#pragma mark create properties
- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier {
    return self.objectDictionary[identifier.key];
}

#pragma mark save/remove resource in objectRegistry
- (void)setResourceObject:(XCResource *)resource {
    self.objectDictionary[resource.identifier.key] = resource.properties;
}

- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier {
    [self.objectDictionary removeObjectForKey:identifier.key];
}

#pragma mark Removal of Unreferenced Resources

- (void)addObjectIdentifiersInDictionary:(NSDictionary *)dict toSet:(NSMutableSet *)set {
    for (id object in dict.allValues) {
        if ([object isKindOfClass:[XCObjectIdentifier class]]) [set addObject:object];
        else if ([object isKindOfClass:[NSDictionary class]]) [self addObjectIdentifiersInDictionary:object toSet:set];
        else if ([object isKindOfClass:[NSArray class]]) [self addObjectIdentifiersInArray:object toSet:set];
    }
}

- (void)addObjectIdentifiersInArray:(NSArray *)list toSet:(NSMutableSet *)set {
    for (id object in list) {
        if ([object isKindOfClass:[XCObjectIdentifier class]]) [set addObject:object];
        else if ([object isKindOfClass:[NSDictionary class]]) [self addObjectIdentifiersInDictionary:object toSet:set];
        else if ([object isKindOfClass:[NSArray class]]) [self addObjectIdentifiersInArray:object toSet:set];
    }
}

- (void)removeUnreferencedResources {
    NSMutableSet *set = [NSMutableSet set];
    [self addObjectIdentifiersInDictionary:self.objectDictionary toSet:set];
    
    NSMutableArray *keysToRemove = [NSMutableArray array];
    for (NSString *key in self.objectDictionary.allKeys) {
        if (![set containsObject:key]) [keysToRemove addObject:key];
    }
    
    for (NSString *key in keysToRemove) {
        [self.objectDictionary removeObjectForKey:key];
    }
}

#pragma mark save PBXProject
- (void)save
{
    [self.projectPropertyList writeToFile:_filePath atomically:YES];
}

@end
