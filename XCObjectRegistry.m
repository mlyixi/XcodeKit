//
//  XCObjectRegistry.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCObjectRegistry.h"
#import "XCResource.h"

@implementation XCObjectRegistry

- (id)init {
    return [self initWithProjectPropertyList:[NSDictionary dictionary]];
}

- (id)initWithProjectPropertyList:(NSDictionary *)propertyList {
    self = [super init];
    
    if (self) {
        _projectPropertyList = [propertyList mutableCopy];
    }
    
    return self;
}

- (NSInteger)objectVersion {
    return [self.projectPropertyList[@"objectVersion"] integerValue];
}

- (void)setObjectVersion:(NSInteger)archiveVersion {
    self.projectPropertyList[@"objectVersion"] = @(archiveVersion);
}

- (XCResource *)rootObject {
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithKey:self.projectPropertyList[@"rootObject"] targetDescription:@"Project object"];
    return [self objectWithIdentifier:identifier];
}

- (NSMutableDictionary *)objectDictionary {
    return self.projectPropertyList[@"objects"];
}

- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier {
    return [[XCResource alloc] initWithIdentifier:identifier registry:self];
}

- (id)objectOfClass:(Class)cls withIdentifier:(XCObjectIdentifier *)identifier {
    NSAssert([cls isKindOfClass:[XCResource class]], @"Class %@ must inherit from XCResource", NSStringFromClass(cls));
    return [[cls alloc] initWithIdentifier:identifier registry:self];
}

- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier {
    return self.objectDictionary[identifier.key];
}

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties {
    NSAssert([cls isKindOfClass:[XCResource class]], @"Class %@ must inherit from XCResource", NSStringFromClass(cls));
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithTargetDescription:nil existingKeys:self.objectDictionary.allKeys];
    self.objectDictionary[identifier.key] = properties;
    
    return [[cls alloc] initWithIdentifier:identifier registry:self];
}

- (void)setResourceObject:(XCResource *)resource {
    self.objectDictionary[resource.identifier.key] = resource.properties;
}

- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier {
    [self.objectDictionary removeObjectForKey:identifier.key];
}

@end
