//
//  XCProject.h
//  PodBuilder
//
//  Created by William Kent on 5/13/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"
#import "XCFileReference.h"
#import "XCConfigurationList.h"
#import "XCTarget.h"
#import "XCGroup.h"

@interface XCProject : XCResource

// This method creates the product-reference group as "Products" at the end of the main XCGroup. It also creates an empty XCConfigurationList.
+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group inRegistry:(XCObjectRegistry *)registry;
// This method creates an empty XCConfigurationList.
+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup inRegistry:(XCObjectRegistry *)registry;
+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup buildConfigurationList:(XCConfigurationList *)configurationList inRegistry:(XCObjectRegistry *)registry;

#pragma mark Properties

@property (strong) XCConfigurationList *configurationList;
@property (strong) XCGroup *mainGroup;
@property (strong) XCGroup *productReferenceGroup;
@property (strong) NSMutableArray *targets;

@end
