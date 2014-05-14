//
//  XCConfigurationList.m
//  PodBuilder
//
//  Created by William Kent on 5/12/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCConfigurationList.h"

@implementation XCConfigurationList

+ (XCConfigurationList *)createConfigurationListInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"XCConfigurationList";
        defaultProperties[@"buildConfigurations"] = [NSMutableArray array];
        defaultProperties[@"defaultConfigurationIsVisible"] = @"0";
        defaultProperties[@"defaultConfigurationName"] = @"";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}


- (NSArray *)configurations {
    NSMutableArray *retval = [NSMutableArray array];
    for (XCObjectIdentifier *ident in self.properties[@"buildConfigurations"]) {
        [retval addObject:[self.registry objectOfClass:[XCConfiguration class] withIdentifier:ident]];
    }
    
    return retval;
}

- (void)addConfigurationWithName:(NSString *)configName {
    [self addConfigurationWithName:configName block:NULL];
}

- (void)addConfigurationWithName:(NSString *)configName block:(void (^)(XCConfiguration *configuration))block {
    XCConfiguration *configuration = [XCConfiguration createConfigurationWithName:configName inRegistry:self.registry];
    [self.properties[@"buildConfigurations"] addObject:configuration.identifier];
    
    if (block != NULL) block(configuration);
    [configuration saveToObjectRegistry];
}

- (void)removeConfigurationWithName:(NSString *)configName {
    XCConfiguration *configurationToRemove = nil;
    for (XCConfiguration *config in self.configurations) {
        if ([config.name isEqualToString:configName]) {
            configurationToRemove = config;
            break;
        }
    }
    
    [self.properties[@"buildConfigurations"] removeObject:configurationToRemove.identifier];
}

- (NSString *)defaultConfigurationName {
    return self.properties[@"defaultConfigurationName"];
}

- (void)setDefaultConfigurationName:(NSString *)name {
    self.properties[@"defaultConfigurationName"] = name;
}

@end
