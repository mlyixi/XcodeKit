//
//  XCObjectRegistry.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCObjectIdentifier.h"

@class XCResource;
@interface XCObjectRegistry : NSObject

- (id)initWithProjectPropertyList:(NSDictionary *)propertyList;

@property (readonly, strong) NSMutableDictionary *projectPropertyList;
@property (assign) NSInteger objectVersion;

- (XCResource *)rootObject;
- (NSMutableDictionary *)objectDictionary;

- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier;
- (id)objectOfClass:(Class)cls withIdentifier:(XCObjectIdentifier *)identifier;
- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier;

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties;
- (void)setResourceObject:(XCResource *)resource;
- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier;

@end
