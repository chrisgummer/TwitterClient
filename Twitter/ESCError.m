//
//  ESCError.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCError.h"

NSString * const ESCErrorDomain = @"ESCErrorDomain";

@implementation ESCError

+ (instancetype)errorWithCode:(ESCErrorCode)code localizedDescription:(NSString *)localizedDescription {
    return [self errorWithCode:code localizedDescription:localizedDescription underlyingError:nil];
}

+ (instancetype)errorWithCode:(ESCErrorCode)code localizedDescription:(NSString *)localizedDescription underlyingError:(NSError *)underlyingError {
    NSMutableDictionary *userInfo = [@{ NSLocalizedDescriptionKey : NSLocalizedString(@"error.parse", nil) } mutableCopy];
    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }
    return [NSError errorWithDomain:ESCErrorDomain code:code userInfo:[userInfo copy]];
}

@end
