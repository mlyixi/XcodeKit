//
//  XCGroup.m
//  PodBuilder
//
//  Created by William Kent on 5/12/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCGroup.h"
#import "NSArray+MapFoldReduce.h"

@implementation XCGroup

+ (NSString *)propertiesClassTypeName {
    // This method exists to allow XCVariantGroup to supply its own isa for
    // the properties of instances of that subclass, without having to reimplement
    // the rest of +createLogicalGroupWithName:inRegistry:. DRY, anyone?
    return @"PBXGroup";
}

+ (XCGroup *)createLogicalGroupWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = [[self class] propertiesClassTypeName];
        defaultProperties[@"sourceTree"] = @"<group>";
        defaultProperties[@"children"] = [NSMutableArray array];
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    
    XCGroup *retval = [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
    retval.resourceDescription = name;
    return retval;
}

- (NSArray *)children {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"children"]) {
        [retval addObject:[self.registry objectWithIdentifier:ident]];
    }
    
    return retval;
}

- (NSArray *)childGroups {
    NSArray *array = [self.children arrayWithObjectsPassingTest:^BOOL(id object) {
        return [object isKindOfClass:[XCGroup class]];
    }];
    
    return [array arrayByTranslatingValues:^id(id oldValue) {
        XCGroup *group = oldValue;
        group.parentGroup = self;
        return group;
    }];
}

- (NSArray *)childFiles {
    return [self.children arrayWithObjectsNotPassingTest:^BOOL(id object) {
        return [object isKindOfClass:[XCGroup class]];
    }];
}

- (void)addChildGroup:(XCGroup *)group {
    [self.properties[@"children"] addObject:group.identifier];
    [self.registry setResourceObject:group];
}

- (void)addChildFileReference:(XCFileReference *)reference {
    [self.properties[@"children"] addObject:reference.identifier];
    [self.registry setResourceObject:reference];
}

- (void)removeChild:(XCResource *)resource {
    [self.properties[@"children"] removeObject:resource];
}

- (void)removeFromParentGroup {
    for (XCGroup *group in self.childGroups) {
        [group removeFromParentGroup];
    }
    
    for (XCFileReference *ref in self.childFiles) {
        [ref removeFromParentGroup];
    }
    
    [self.parentGroup removeChild:self];
}

@end

#pragma mark -

@implementation XCVariantGroup

+ (NSString *)propertiesClassTypeName {
    return @"PBXVariantGroup";
}

@end
