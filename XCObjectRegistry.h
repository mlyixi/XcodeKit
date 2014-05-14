//
//  XCObjectRegistry.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCObjectIdentifier.h"

extern NSString * const XCInvalidProjectFileException;

@class XCResource;
@interface XCObjectRegistry : NSObject

+ (XCObjectRegistry *)objectRegistryWithXcodePBXProjectText:(NSString *)pbxproj;
- (id)initWithProjectPropertyList:(NSDictionary *)propertyList;

@property (readonly, strong) NSMutableDictionary *projectPropertyList;
@property (strong) XCResource *rootObject;
@property (assign) NSInteger objectVersion;

- (NSString *)xcodePBXProjectText;
- (NSMutableDictionary *)objectDictionary;
- (void)removeUnreferencedResources;

// If the XCResource instance returned from this method has its resourceDescription
// property set to a non-nil value, its value will be propagated to the targetDescription
// property on the passed-in XCObjectIdentifier.
- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier;
- (id)objectOfClass:(Class)cls withIdentifier:(XCObjectIdentifier *)identifier;
- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier;

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties;
- (void)setResourceObject:(XCResource *)resource;
- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier;

@end
