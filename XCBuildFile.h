//
//  XCBuildFile.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"
#import "XCFileReference.h"

@interface XCBuildFile : XCResource

+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference inRegistry:(XCObjectRegistry *)registry;
+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry;
+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;

#pragma mark Properties

@property (strong) XCFileReference *fileReference;
@property (strong) NSDictionary *buildSettings;

@end
