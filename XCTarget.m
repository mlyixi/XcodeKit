//
//  XCTarget.m
//  PodBuilder
//
//  Created by William Kent on 5/13/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCTarget.h"

@implementation XCTarget

+ (XCTarget *)createApplicationTargetWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXNativeTarget";
        defaultProperties[@"buildPhases"] = [NSMutableArray array];
        defaultProperties[@"buildRules"] = [NSMutableArray array];
        defaultProperties[@"dependencies"] = [NSMutableArray array];
        defaultProperties[@"productType"] = @"com.apple.product-type.application";
    });
    
    XCConfigurationList *configurationList = [XCConfigurationList createConfigurationListInRegistry:registry];
    configurationList.resourceDescription = [NSString stringWithFormat:@"Build configuration list for PBXNativeTarget \"%@\"", name];
    [registry setResourceObject:configurationList];
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    finalProperties[@"productName"] = name;
    finalProperties[@"buildConfigurationList"] = configurationList.identifier;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

+ (XCTarget *)createAggregateTargetWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXAggregateTarget";
        defaultProperties[@"buildRules"] = [NSMutableArray array];
        defaultProperties[@"dependencies"] = [NSMutableArray array];
    });
    
    XCConfigurationList *configurationList = [XCConfigurationList createConfigurationListInRegistry:registry];
    configurationList.resourceDescription = [NSString stringWithFormat:@"Build configuration list for PBXNativeTarget \"%@\"", name];
    [registry setResourceObject:configurationList];
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    finalProperties[@"productName"] = name;
    finalProperties[@"buildConfigurationList"] = configurationList.identifier;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties

- (XCConfigurationList *)configurationList {
    return (XCConfigurationList *) [self.registry objectWithIdentifier:self.properties[@"buildConfigurationList"]];
}

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
}

- (NSString *)productName {
    return self.properties[@"productName"];
}

- (void)setProductName:(NSString *)productName {
    self.properties[@"productName"] = productName;
}

- (XCFileReference *)productReference {
    return [self.registry objectOfClass:[XCFileReference class] withIdentifier:self.properties[@"productReference"]];
}

- (void)setProductReference:(XCFileReference *)productReference {
    self.properties[@"productReference"] = productReference.identifier;
}

- (NSArray *)buildDependencies {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"dependencies"]) {
        [retval addObject:[self.registry objectOfClass:[XCTargetDependency class] withIdentifier:ident]];
    }
    
    return retval;
}

- (void)addBuildDependency:(XCTargetDependency *)dependency {
    [self.properties[@"dependencies"] addObject:dependency.identifier];
}

- (BOOL)removeBuildDependency:(XCTargetDependency *)dependency {
    if ([self.properties[@"dependencies"] containsObject:dependency.identifier]) {
        [self.properties[@"dependencies"] removeObject:dependency.identifier];
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)buildPhases {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"buildPhases"]) {
        [retval addObject:[self.registry objectOfClass:[XCBuildPhase class] withIdentifier:ident]];
    }
    
    return retval;
}

- (NSUInteger)buildPhaseCount {
    return [self.properties[@"buildPhases"] count];
}

- (void)addBuildPhase:(XCBuildPhase *)phase {
    [self.properties[@"buildPhases"] addObject:phase.identifier];
}

- (void)insertBuildPhase:(XCBuildPhase *)phase atIndex:(NSUInteger)index {
    [self.properties[@"buildPhases"] insertObject:phase.identifier atIndex:index];
}

- (void)removeBuildPhase:(XCBuildPhase *)phase {
    [self.properties[@"buildPhases"] removeObject:phase.identifier];
}

@end

#pragma mark -

@implementation XCContainerItemProxy

+ (XCContainerItemProxy *)createContainerItemProxyWithProjectIdentifier:(XCObjectIdentifier *)projectIdentifier targetIdentifier:(XCObjectIdentifier *)targetIdentifier targetName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXContainerItemProxy";
        defaultProperties[@"proxyType"] = @"1";
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"containerPortal"] = projectIdentifier;
    finalProperties[@"remoteGlobalIDString"] = targetIdentifier;
    finalProperties[@"remoteInfo"] = name;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

+ (XCContainerItemProxy *)createContainerItemProxyWithProjectIdentifier:(XCObjectIdentifier *)projectIdentifier target:(XCTarget *)target inRegistry:(XCObjectRegistry *)registry {
    return [self createContainerItemProxyWithProjectIdentifier:projectIdentifier targetIdentifier:target.identifier targetName:target.name inRegistry:registry];
}

#pragma mark Properties

- (XCObjectIdentifier *)projectIdentifier {
    return self.properties[@"containerPortal"];
}

- (XCObjectIdentifier *)targetIdentifier {
    return self.properties[@"remoteGlobalIDString"];
}

- (NSString *)targetName {
    return self.properties[@"name"];
}

@end

#pragma mark -

@implementation XCTargetDependency

+ (XCTargetDependency *)createTargetDependencyWithTarget:(XCTarget *)target targetProxy:(XCContainerItemProxy *)proxy inRegistry:(XCObjectRegistry *)registry {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"isa"] = @"PBXTargetDependency";
    properties[@"target"] = target.identifier;
    properties[@"targetProxy"] = proxy.identifier;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:properties];
}

#pragma mark Properties

- (XCTarget *)target {
    return [self.registry objectOfClass:[XCTarget class] withIdentifier:self.properties[@"target"]];
}

- (XCContainerItemProxy *)targetProxy {
    return [self.registry objectOfClass:[XCContainerItemProxy class] withIdentifier:self.properties[@"targetProxy"]];
}

@end
