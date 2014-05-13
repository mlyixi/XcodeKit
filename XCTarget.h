//
//  XCTarget.h
//  PodBuilder
//
//  Created by William Kent on 5/13/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"
#import "XCBuildPhase.h"
#import "XCFileReference.h"
#import "XCConfigurationList.h"

@class XCTargetDependency;
@interface XCTarget : XCResource

+ (XCTarget *)createApplicationTargetWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry;
+ (XCTarget *)createAggregateTargetWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry;

#pragma mark Properties

@property (strong) NSString *name;
@property (strong) NSString *productName;
@property (strong) XCFileReference *productReference;

- (XCConfigurationList *)configurationList;

- (NSArray *)buildDependencies;
- (void)addBuildDependency:(XCTargetDependency *)dependency;
// This method returns YES if the build dependency was found and removed
// or NO if the dependency was not found the buildDependencies array.
- (BOOL)removeBuildDependency:(XCTargetDependency *)dependency;

- (NSArray *)buildPhases;
- (NSUInteger)buildPhaseCount;
- (void)addBuildPhase:(XCBuildPhase *)phase;
- (void)insertBuildPhase:(XCBuildPhase *)phase atIndex:(NSUInteger)index;
- (void)removeBuildPhase:(XCBuildPhase *)phase;

@end

#pragma mark -

@interface XCContainerItemProxy : XCResource

+ (XCContainerItemProxy *)createContainerItemProxyWithProjectIdentifier:(XCObjectIdentifier *)projectIdentifier targetIdentifier:(XCObjectIdentifier *)targetIdentifier targetName:(NSString *)name inRegistry:(XCObjectRegistry *)registry;
+ (XCContainerItemProxy *)createContainerItemProxyWithProjectIdentifier:(XCObjectIdentifier *)projectIdentifier target:(XCTarget *)target inRegistry:(XCObjectRegistry *)registry;

#pragma mark Properties

// XCContainerItemProxy instances are immutable. If you need to change them, add another one.

/// The \c XCObjectIdentifier of the project reference containing the target that this item proxy points to.
/// \remarks This isn't resolved into an XCFileReference or XCProject instance because it could be either.
@property (readonly, strong) XCObjectIdentifier *projectIdentifier;
/// The \c XCObjectIdentifier of the target this item proxy points to.
/// \remarks This isn't resolved into an XCTarget instance because the
/// identifier may belong to another registry (different than the one
/// that owns the receiver).
@property (readonly, strong) XCObjectIdentifier *targetIdentifier;
/// The name of the target.
@property (readonly, strong) NSString *targetName;

@end

#pragma mark -

@interface XCTargetDependency : XCResource

+ (XCTargetDependency *)createTargetDependencyWithTarget:(XCTarget *)target targetProxy:(XCContainerItemProxy *)proxy inRegistry:(XCObjectRegistry *)registry;

#pragma mark Properties

@property (readonly, strong) XCTarget *target;
@property (readonly, strong) XCContainerItemProxy *targetProxy;

@end
