//
//  XCResource.m
//  PodBuilder
//
//  Created by William Kent on 4/27/14.
//  Copyright (c) 2014 William Kent. All rights reserved.
//

#import "XCResource.h"

@implementation XCResource

- (instancetype)initWithIdentifier:(XCObjectIdentifier *)identifier registry:(XCObjectRegistry *)registry {
    self = [super init];
    
    if (self) {
        _identifier = identifier;
        _registry = registry;
        _properties = [NSMutableDictionary dictionary];
        self.resourceDescription = nil;
    }
    
    return self;
}

- (void)saveToObjectRegistry {
    [self.registry setResourceObject:self];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    XCResource *other = object;
    return [self.registry isEqual:other.registry] && [self.identifier isEqual:other.identifier] && [self.properties isEqual:other.properties];
}

- (NSUInteger)hash {
    return self.registry.hash ^ self.identifier.hash ^ self.properties.hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", self.identifier, self.properties];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ %p: identifier=%@ registry=%@ properties=%@>", NSStringFromClass([self class]), self, self.identifier, self.registry, self.properties];
}

@end
