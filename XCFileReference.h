//
//  XCFileReference.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"

extern NSString * const XCFileReferencePathInGroup;
extern NSString * const XCFileReferencePathInSDK;
extern NSString * const XCFileReferencePathInBuiltProductsDirectory;

@interface XCFileReference : XCResource

+ (XCFileReference *)createFileReferenceForRegularFileInRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForFrameworkWithName:(NSString *)name path:(NSString *)path inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForSDKFrameworkWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForSDKLibraryWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForApplicationProductWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;

#pragma mark Properties

@property (strong) NSString *name;
@property (strong) NSString *path;
// This property's value can be one of XCFileReferencePathInGroup, XCFileReferencePathInSDK, or XCFileReferencePathInBuiltProductsDirectory
@property (strong) NSString *pathResolveBase;
@property (strong) NSString *explicitFileType;
@property (strong) NSString *lastKnownFileType;
@property (assign) BOOL includeInIndex;

@end
