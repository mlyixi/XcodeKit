//
//  XCGroup.h
//  PodBuilder
//
//  Created by William Kent on 5/12/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"
#import "XCFileReference.h"

@interface XCGroup : XCResource

+ (XCGroup *)createLogicalGroupWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry;

@property (strong) XCGroup *parentGroup;

- (NSArray *)children;
- (NSArray *)childGroups;
- (NSArray *)childFiles;

- (void)addChildGroup:(XCGroup *)group;
- (void)addChildFileReference:(XCFileReference *)reference;
- (void)removeChild:(XCResource *)resource;
- (void)removeFromParentGroup;

@end

#pragma mark -

@interface XCVariantGroup : XCGroup

@end
