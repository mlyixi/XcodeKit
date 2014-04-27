//
//  XCBuildFile.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCBuildFile.h"

@implementation XCBuildFile

+ (XCBuildFile *)buildFileWithFileReference:(XCFileReference *)fileReference inRegistry:(XCObjectRegistry *)registry {
    return [self buildFileWithFileReference:fileReference buildSettings:nil inRegistry:registry];
}

+ (XCBuildFile *)buildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry {
    return [self buildFileWithFileReference:fileReference buildSettings:buildSettings inRegistry:registry additionalProperties:nil];
}

+ (XCBuildFile *)buildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXBuildFile";
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    [finalProperties addEntriesFromDictionary:properties];
    finalProperties[@"fileRef"] = fileReference.identifier.key;
    if (buildSettings.count > 0) finalProperties[@"settings"] = buildSettings;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties

- (XCFileReference *)fileReference {
    XCResource *resource = [self.registry objectWithIdentifier:self.properties[@"fileRef"]];
    NSAssert([resource isKindOfClass:[XCFileReference class]], @"File reference %@ doesn't point to a file reference", self.properties[@"fileRef"]);
    return (XCFileReference *)resource;
}

- (void)setFileReference:(XCFileReference *)fileReference {
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithKey:fileReference.identifier.key targetDescription:fileReference.name];
    self.properties[@"fileRef"] = identifier;
}

- (NSDictionary *)buildSettings {
    return self.properties[@"settings"];
}

- (void)setBuildSettings:(NSDictionary *)buildSettings {
    self.properties[@"settings"] = buildSettings;
}

@end
