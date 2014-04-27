//
//  XCProject+XCBuildFile.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCProject.h"
#import "XCObjectIdentifier.h"

@interface XCProject (XCBuildFile)

- (NSDictionary *)createBuildFileWithFileReference:(XCObjectIdentifier *)fileReference;
- (NSDictionary *)createBuildFileWithFileReference:(XCObjectIdentifier *)fileReference buildSettings:(NSDictionary *)settings;

@end
