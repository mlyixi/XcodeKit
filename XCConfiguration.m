//
//  XCConfiguration.m
//  PodBuilder
//
//  Created by William Kent on 5/10/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCConfiguration.h"

NSString * const XCConfigurationNameDebug = @"Debug";
NSString * const XCConfigurationNameRelease = @"Release";

@implementation XCConfiguration

+ (XCConfiguration *)configurationWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    NSMutableDictionary *finalProperties = [[NSMutableDictionary alloc] init];
    finalProperties[@"name"] = name;
    finalProperties[@"buildSettings"] = [NSMutableDictionary dictionary];
    
    return [registry addResourceObjectOfClass:[XCConfiguration class] withProperties:finalProperties];
}

#pragma mark Properties

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
}

- (NSMutableDictionary *)buildSettings {
    return self.properties[@"buildSettings"];
}

@end
