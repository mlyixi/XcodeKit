//
//  XCProject.m
//  PodBuilder
//
//  Created by William Kent on 5/13/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCProject.h"
#import "XCTarget.h"

@implementation XCProject

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group inRegistry:(XCObjectRegistry *)registry {
    XCGroup *productsGroup = [XCGroup createLogicalGroupWithName:@"Products" inRegistry:registry];
    [group addChildGroup:productsGroup];
    return [self createProjectWithMainGroup:group productReferenceGroup:productsGroup inRegistry:registry];
}

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup inRegistry:(XCObjectRegistry *)registry {
    XCConfigurationList *list = [XCConfigurationList createConfigurationListInRegistry:registry];
    return [self createProjectWithMainGroup:group productReferenceGroup:productsGroup buildConfigurationList:list inRegistry:registry];
}

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup buildConfigurationList:(XCConfigurationList *)configurationList inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXProject";
        defaultProperties[@"compatibilityVersion"] = @"Xcode 3.2";
        defaultProperties[@"developmentRegion"] = @"English";
        defaultProperties[@"knownRegions"] = [NSMutableArray array];
        defaultProperties[@"hasScannedForEncodings"] = @"0";
        defaultProperties[@"projectDirPath"] = @"";
        defaultProperties[@"projectRoot"] = @"";
        defaultProperties[@"targets"] = [NSMutableArray array];
        
        NSMutableDictionary *defaultAttributes = [NSMutableDictionary dictionary];
        defaultAttributes[@"LastUpgradeCheck"] = @"0510";
        defaultProperties[@"attributes"] = defaultAttributes;
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"buildConfigurationList"] = configurationList.identifier;
    finalProperties[@"mainGroup"] = group.identifier;
    finalProperties[@"productRefGroup"] = productsGroup.identifier;
    
    [registry setResourceObject:group];
    [registry setResourceObject:productsGroup];
    [registry setResourceObject:configurationList];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties

- (XCConfigurationList *)configurationList {
    return [self.registry objectOfClass:[XCConfigurationList class] withIdentifier:self.properties[@"buildConfigurationList"]];
}

- (void)setConfigurationList:(XCConfigurationList *)configurationList {
    [self.registry setResourceObject:configurationList];
    self.properties[@"buildConfigurationList"] = configurationList.identifier;
}

- (XCGroup *)mainGroup {
    return [self.registry objectOfClass:[XCGroup class] withIdentifier:self.properties[@"mainGroup"]];
}

- (void)setMainGroup:(XCGroup *)mainGroup {
    [self.registry setResourceObject:mainGroup];
    self.properties[@"mainGroup"] = mainGroup.identifier;
}

- (XCGroup *)productReferenceGroup {
    return [self.registry objectOfClass:[XCGroup class] withIdentifier:self.properties[@"productRefGroup"]];
}

- (void)setProductReferenceGroup:(XCGroup *)productReferenceGroup {
    [self.registry setResourceObject:productReferenceGroup];
    self.properties[@"productRefGroup"] = productReferenceGroup.identifier;
}

- (NSMutableArray *)targets {
    NSMutableArray *array = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"targets"]) {
        [array addObject:[self.registry objectOfClass:[XCTarget class] withIdentifier:ident]];
    }
    
    return array;
}

- (void)setTargets:(NSMutableArray *)targets {
    NSMutableArray *identifiers = [NSMutableArray array];
    
    for (XCTarget *target in targets) {
        [self.registry setResourceObject:target];
        [identifiers addObject:target.identifier];
    }
    
    self.properties[@"targets"] = identifiers;
}

- (NSMutableDictionary *)attributes {
    return self.properties[@"attributes"];
}

- (void)setAttributes:(NSMutableDictionary *)attributes {
    self.properties[@"attributes"] = attributes;
}

@end
