//
//  XCProject+XCBuildFile.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCProject+XCBuildFile.h"

@implementation XCProject (XCBuildFile)

- (NSDictionary *)createBuildFileWithFileReference:(XCObjectIdentifier *)fileReference {
    return [self createBuildFileWithFileReference:fileReference buildSettings:nil];
}

- (NSDictionary *)createBuildFileWithFileReference:(XCObjectIdentifier *)fileReference buildSettings:(NSDictionary *)settings {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"isa"] = @"PBXBuildFile";
    properties[@"fileRef"] = fileReference;
    
    if (settings.count > 0) properties[@"settings"] = settings;
    
    return properties;
}

@end
