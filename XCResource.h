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

/// This is the description of the resource, as used in the \c targetDescription property on \c XCObjectIdentifier.
/// \par Setting this property will automatically propagate its value to all new XCObjectIdentifiers created after this
/// property is set. This value will also be written out to the pbxproj file.
@property (strong) NSString *resourceDescription;

@end
