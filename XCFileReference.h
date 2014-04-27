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

+ (XCFileReference *)fileReferenceForRegularFileInRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)fileReferenceForFrameworkWithName:(NSString *)name path:(NSString *)path inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)fileReferenceForSDKFrameworkWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)fileReferenceForSDKLibraryWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)fileReferenceForApplicationProductWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;

#pragma mark Properties

@property (strong) NSString *name;
@property (strong) NSString *path;
// This property's value can be one of XCFileReferencePathInGroup, XCFileReferencePathInSDK, or XCFileReferencePathInBuiltProductsDirectory
@property (strong) NSString *pathResolveBase;
@property (strong) NSString *explicitFileType;
@property (strong) NSString *lastKnownFileType;
@property (assign) BOOL includeInIndex;

@end
