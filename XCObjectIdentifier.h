//
//  XCObjectIdentifier.h
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCObjectIdentifier : NSObject <NSSecureCoding>

/// Creates a new, unique XCObjectIdentifier.
- (id)init;

/// Creates a new, unique XCObjectIdentifier with the given \c targetDescription .
- (id)initWithTargetDescription:(NSString *)targetDescription;

/// Creates a new, unique XCObjectIdentifier with the given \c targetDescription .
/// The \c key is guaranteed to not be equal to any of the keys in the \c existingKeys array.
- (instancetype)initWithTargetDescription:(NSString *)targetDescription existingKeys:(NSArray *)existingKeys;

/// Creates an instance of \c XCObjectIdentifier with the given \c key and \c targetDescription .
/// This is the designated initializer.
- (instancetype)initWithKey:(NSString *)key targetDescription:(NSString *)targetDescription;

#pragma mark Properties

/// The randomly generated key string. This is composed of 24 uppercase hexadecimal characters.
@property (readonly, strong) NSString *key;

/// A string that describes what the \c key points to. This will be
/// written in a comment when the Xcode project is formatted for output.
@property (strong) NSString *targetDescription;

@end
