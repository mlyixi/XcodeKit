//
//  XCObjectIdentifier.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCObjectIdentifier.h"

@implementation XCObjectIdentifier

+ (NSString *)generateRandomKey {
    NSString *possibleKeyCharacters = @"0123456789ABCDEF";
    const uint32_t keyCharacterCount = (uint32_t)[possibleKeyCharacters length];
    const NSInteger keyLength = 24;
    
    NSMutableString *key = [NSMutableString string];
    for (NSInteger i = 0; i < keyLength; i++) {
        unichar c = [possibleKeyCharacters characterAtIndex:arc4random_uniform(keyCharacterCount)];
        [key appendFormat:@"%C", c];
    }
    
    return key;
}

- (id)init {
    return [self initWithTargetDescription:nil existingKeys:@[]];
}

- (id)initWithTargetDescription:(NSString *)targetDescription {
    return [self initWithTargetDescription:targetDescription existingKeys:@[]];
}

- (id)initWithTargetDescription:(NSString *)targetDescription existingKeys:(NSArray *)existingKeys {
    const NSInteger maxIterations = 10;
    NSInteger iterationCount = 0;
    
    NSString *newIdentifier = [[self class] generateRandomKey];
    while ([existingKeys containsObject:newIdentifier]) {
        newIdentifier = [[self class] generateRandomKey];
        
        iterationCount++;
        NSAssert(iterationCount <= maxIterations, @"Could not generate a unique XCObjectIdentifier key after %ld attempts", (long)maxIterations);
    }
    
    return [self initWithKey:newIdentifier targetDescription:targetDescription];
}

- (id)initWithKey:(NSString *)key targetDescription:(NSString *)targetDescription {
    self = [super init];
    
    if (self) {
        _key = key;
        _targetDescription = targetDescription;
    }
    
    return self;
}

#pragma mark NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.key forKey:@"XCObjectKey"];
    [coder encodeObject:self.targetDescription forKey:@"XCTargetObjectDescription"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    
    if (self) {
        _key = [coder decodeObjectOfClass:[NSString class] forKey:@"XCObjectKey"];
        _targetDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"XCTargetObjectDescription"];
    }
    
    return self;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    XCObjectIdentifier *other = object;
    return [self.key isEqualToString:other.key] && [self.targetDescription isEqualToString:other.targetDescription];
}

- (NSUInteger)hash {
    return self.key.hash ^ self.targetDescription.hash;
}

- (NSString *)description {
    if (self.targetDescription != nil) return [NSString stringWithFormat:@"%@ /* %@ */", self.key, self.targetDescription];
    else return self.key;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ %p: key=%@ targetDescription=%@>", NSStringFromClass([self class]), self, self.key, self.targetDescription];
}

@end
