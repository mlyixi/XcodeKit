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
{
    NSMutableDictionary *identifierDescriptions;
}

- (id)init {
    return [self initWithProjectPropertyList:[NSDictionary dictionary]];
}

- (id)initWithProjectPropertyList:(NSDictionary *)propertyList {
    self = [super init];
    
    if (self) {
        _projectPropertyList = [propertyList mutableCopy];
        identifierDescriptions = [NSMutableDictionary dictionary];
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
    return [self addResourceObjectOfClass:cls withProperties:properties description:nil];
}

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties description:(NSString *)objectDescription {
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithTargetDescription:objectDescription existingKeys:self.objectDictionary.allKeys];
    return [self addResourceObjectOfClass:cls withProperties:properties identifier:identifier];
}

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties identifier:(XCObjectIdentifier *)identifier {
    NSAssert([cls isKindOfClass:[XCResource class]], @"Class %@ must inherit from XCResource", NSStringFromClass(cls));
    self.objectDictionary[identifier.key] = properties;
    
    identifierDescriptions[identifier.key] = identifier.targetDescription;
    return [[cls alloc] initWithIdentifier:identifier registry:self];
}

- (void)setResourceObject:(XCResource *)resource {
    self.objectDictionary[resource.identifier.key] = resource.properties;
}

- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier {
    [self.objectDictionary removeObjectForKey:identifier.key];
}

@end
