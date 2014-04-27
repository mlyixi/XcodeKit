//
//  XCResource.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCObjectIdentifier.h"
#import "XCObjectRegistry.h"

@interface XCResource : NSObject

- (instancetype)initWithIdentifier:(XCObjectIdentifier *)identifier registry:(XCObjectRegistry *)registry;
- (void)saveToObjectRegistry;

#pragma mark Properties

@property (readonly, strong) XCObjectRegistry *registry;
@property (readonly, strong) XCObjectIdentifier *identifier;
@property (readonly, strong) NSMutableDictionary *properties;

@end
