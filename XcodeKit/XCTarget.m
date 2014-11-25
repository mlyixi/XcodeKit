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

#import "XCTarget.h"

@implementation XCTarget

# pragma mark constractors
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
    [registry setResourceObject:configurationList];
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    finalProperties[@"productName"] = name;
    finalProperties[@"buildConfigurationList"] = configurationList.identifier.key;
    
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
    [registry setResourceObject:configurationList];
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    finalProperties[@"productName"] = name;
    finalProperties[@"buildConfigurationList"] = configurationList.identifier.key;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties
- (XCConfigurationList *)configurationList {
    return [self.registry objectOfClass:[XCConfigurationList class] withKey:self.properties[@"buildConfigurationList"]];
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
    return [self.registry objectOfClass:[XCFileReference class] withKey:self.properties[@"productReference"]];
}

- (void)setProductReference:(XCFileReference *)productReference {
    self.properties[@"productReference"] = productReference.identifier.key;
}

- (NSArray *)buildDependencies {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (NSString *key in self.properties[@"dependencies"]) {
        [retval addObject:[self.registry objectOfClass:[XCTargetDependency class] withKey:key]];
    }
    
    return retval;
}

- (void)addBuildDependency:(XCTargetDependency *)dependency {
    [self.properties[@"dependencies"] addObject:dependency.identifier.key];
}

- (BOOL)removeBuildDependency:(XCTargetDependency *)dependency {
    if ([self.properties[@"dependencies"] containsObject:dependency.identifier.key]) {
        [self.properties[@"dependencies"] removeObject:dependency.identifier.key];
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)buildPhases {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (NSString *key in self.properties[@"buildPhases"]) {
        [retval addObject:[self.registry objectOfClass:[XCBuildPhase class] withKey:key]];
    }
    return retval;
}

- (NSUInteger)buildPhaseCount {
    return [self.properties[@"buildPhases"] count];
}

- (void)addBuildPhase:(XCBuildPhase *)phase {
    [self.properties[@"buildPhases"] addObject:phase.identifier.key];
}

- (void)insertBuildPhase:(XCBuildPhase *)phase atIndex:(NSUInteger)index {
    [self.properties[@"buildPhases"] insertObject:phase.identifier.key atIndex:index];
}

- (void)removeBuildPhase:(XCBuildPhase *)phase {
    [self.properties[@"buildPhases"] removeObject:phase.identifier.key];
    [self.registry removeResourceObjectWithIdentifier:phase.identifier];
}

@end




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
    finalProperties[@"containerPortal"] = projectIdentifier.key;
    finalProperties[@"remoteGlobalIDString"] = targetIdentifier.key;
    finalProperties[@"remoteInfo"] = name;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

+ (XCContainerItemProxy *)createContainerItemProxyWithProjectIdentifier:(XCObjectIdentifier *)projectIdentifier target:(XCTarget *)target inRegistry:(XCObjectRegistry *)registry {
    return [self createContainerItemProxyWithProjectIdentifier:projectIdentifier targetIdentifier:target.identifier targetName:target.name inRegistry:registry];
}

/// @properties
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





@implementation XCTargetDependency

+ (XCTargetDependency *)createTargetDependencyWithTarget:(XCTarget *)target targetProxy:(XCContainerItemProxy *)proxy inRegistry:(XCObjectRegistry *)registry {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"isa"] = @"PBXTargetDependency";
    properties[@"target"] = target.identifier.key;
    properties[@"targetProxy"] = proxy.identifier.key;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:properties];
}

/// @properties
- (XCTarget *)target {
    return [self.registry objectOfClass:[XCTarget class] withKey:self.properties[@"target"]];
}

- (XCContainerItemProxy *)targetProxy {
    return [self.registry objectOfClass:[XCContainerItemProxy class] withKey:self.properties[@"targetProxy"]];
}

@end
