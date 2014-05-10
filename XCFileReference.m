//
//  XCFileReference.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCFileReference.h"

NSString * const XCFileReferencePathInGroup = @"<group>";
NSString * const XCFileReferencePathInSDK = @"SDKROOT";
NSString * const XCFileReferencePathInBuiltProductsDirectory = @"BUILT_PRODUCTS_DIR";

@implementation XCFileReference

+ (XCFileReference *)fileReferenceForRegularFileInRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInGroup;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)fileReferenceForFrameworkWithName:(NSString *)name path:(NSString *)path inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"wrapper.framework";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInGroup;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = [name.pathExtension isEqualToString:@"framework"] ? [name stringByDeletingPathExtension] : name;
    retval[@"path"] = path;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)fileReferenceForSDKFrameworkWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"wrapper.framework";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInSDK;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = [name.pathExtension isEqualToString:@"framework"] ? [name stringByDeletingPathExtension] : name;
    retval[@"path"] = [NSString stringWithFormat:@"System/Library/Frameworks/%@", retval[@"name"]];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)fileReferenceForSDKLibraryWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"compiled.mach-o.dylib";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInSDK;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = name;
    retval[@"path"] = [NSString stringWithFormat:@"usr/lib/%@", name];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)fileReferenceForApplicationProductWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"explicitFileType"] = @"wrapper.application";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInBuiltProductsDirectory;
        defaultProperties[@"includeInIndex"] = @"0";
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = name;
    retval[@"path"] = [NSString stringWithFormat:@"%@.app", name];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

#pragma mark Properties

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
    [self saveToObjectRegistry];
}

- (NSString *)path {
    return self.properties[@"path"];
}

- (void)setPath:(NSString *)path {
    self.properties[@"path"] = path;
    [self saveToObjectRegistry];
}

- (NSString *)pathResolveBase {
    return self.properties[@"sourceTree"];
}

- (void)setPathResolveBase:(NSString *)pathResolveBase {
    self.properties[@"sourceTree"] = pathResolveBase;
    [self saveToObjectRegistry];
}

- (NSString *)explicitFileType {
    return self.properties[@"explicitFileType"];
}

- (void)setExplicitFileType:(NSString *)explicitFileType {
    self.properties[@"explicitFileType"] = explicitFileType;
    [self saveToObjectRegistry];
}

- (BOOL)includeInIndex {
    NSString *val = self.properties[@"includeInIndex"];
    
    // Default to YES.
    if (val == nil) {
        return YES;
    } else if ([val isEqualToString:@"1"]) {
        return YES;
    } else if ([val isEqualToString:@"0"]) {
        return NO;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unrecognized 'includeInIndex' value: %@", val];
        return YES;
    }
}

- (void)setIncludeInIndex:(BOOL)includeInIndex {
    self.properties[@"includeInIndex"] = includeInIndex ? @"1" : @"0";
    [self saveToObjectRegistry];
}

@end
