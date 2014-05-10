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

- (NSString *)expandedBuildSettingValueForName:(NSString *)name {
    NSError *error;
    NSRegularExpression * const settingPattern = [NSRegularExpression regularExpressionWithPattern:@"\\$\\(([^)]+)\\)" options:0 error:&error];
    NSAssert(settingPattern != nil, @"Could not compile setting pattern: %@", error);
    
    NSString *setting = self.buildSettings[name];
    NSMutableString *retval = [name mutableCopy];
    [settingPattern enumerateMatchesInString:setting options:0 range:NSMakeRange(0, setting.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *name = [setting substringWithRange:[result rangeAtIndex:1]];
        [retval replaceCharactersInRange:result.range withString:[self expandedBuildSettingValueForName:name]];
    }];
    
    return retval;
}

@end
