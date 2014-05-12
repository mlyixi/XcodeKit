//
//  XCConfiguration.h
//  PodBuilder
//
//  Created by William Kent on 5/10/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"

extern NSString * const XCConfigurationNameDebug;
extern NSString * const XCConfigurationNameRelease;

@interface XCConfiguration : XCResource

// Note that this method doesn't add any values to the instance's buildSettings property.
+ (XCConfiguration *)createConfigurationWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry;

#pragma mark Properties

@property (strong) NSString *name;
@property (readonly, strong) NSMutableDictionary *buildSettings;

- (NSString *)expandedBuildSettingValueForName:(NSString *)name;

@end
