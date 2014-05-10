//
//  XCProject.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCProject.h"

NSString * const XCInvalidProjectFileException = @"XCInvalidProjectFileException";
extern XCObjectRegistry * XCParsePBXProjectFile(NSString *pbxprojSource);

@implementation XCProject

- (id)init {
    self = [super init];
    
    if (self) {
        _registry = [[XCObjectRegistry alloc] init];
    }
    
    return self;
}

- (id)initWithPBXProjectData:(NSData *)data {
    self = [super init];
    
    if (self) {
        NSString *source = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _registry = XCParsePBXProjectFile(source);
    }
    
    return self;
}

@end
