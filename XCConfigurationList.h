//
//  XCConfigurationList.h
//  PodBuilder
//
//  Created by William Kent on 5/12/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"
#import "XCConfiguration.h"

@interface XCConfigurationList : XCResource

+ (XCConfigurationList *)configurationListInRegistry:(XCObjectRegistry *)registry;

- (NSArray *)configurations;
- (void)addConfigurationWithName:(NSString *)configName;
- (void)addConfigurationWithName:(NSString *)configName block:(void (^)(XCConfiguration *configuration))block;
- (void)removeConfigurationWithName:(NSString *)configName;

- (NSString *)defaultConfigurationName;
- (void)setDefaultConfigurationName:(NSString *)name;

@end
