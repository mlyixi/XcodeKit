//
//  XCProject.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCObjectRegistry.h"

extern NSString * const XCInvalidProjectFileException;

@interface XCProject : NSObject

/// Creates a new, empty project.
- (id)init;
/// Creates a project by parsing the given \c NSData object.
- (id)initWithPBXProjectData:(NSData *)data;

#pragma mark Properties

@property (readonly, strong) XCObjectRegistry *registry;

@end
