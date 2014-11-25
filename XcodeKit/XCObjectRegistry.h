/*
 * The sources in the "XcodeKit" directory are based on the Ruby project Xcoder.
 *
 * Copyright (c) 2012 cisimple
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "XCObjectIdentifier.h"

extern NSString * const XCInvalidProjectFileException;

@class XCResource, XCProject, XCGroup;
@interface XCObjectRegistry : NSObject


// This method create empty XCObjectRegistry instance
+ (XCObjectRegistry *)objectRegistryForEmptyProjectWithName:(NSString *)projectName;

/// These methods return XCObjectRegistry instance from XcodeProject
+ (XCObjectRegistry *)objectRegistryWithXcodeProject:(NSString *)filePath;
- (id)initWithXcodeProject:(NSString *)filePath;

/// @properties
@property (copy) NSString *filePath;
@property (assign) NSInteger objectVersion;
@property (readonly, strong) NSMutableDictionary *projectPropertyList;
@property (strong) XCProject *project;

/// save() save the objects to XcodeProject.
- (void)save;

/// the project's objects section.
- (NSMutableDictionary *)objectDictionary;


/// return the abstract XCResource instance from its identifier.
- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier;

/// return the real XCResource instance from its identifier. As the parent cannot cast to child, this method is much useful.
- (id)objectOfClass:(Class)cls withKey:(NSString *)key;

/// return the XCResource's properties from its identifier. We modify the object according to its properties which is a value of the objectDictionary
- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier;

/// create a XCResource and add to the objectDictionary
- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties;

/// save the modified XCResource to the objectDictionary
- (void)setResourceObject:(XCResource *)resource;

/// remove XCResource according to the identifier.
- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier;

/// remove all unreferneced XCResources.
- (void)removeUnreferencedResources;

@end
