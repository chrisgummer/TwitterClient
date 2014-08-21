//
//  ESCError.h
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const ESCErrorDomain;

typedef NS_ENUM(NSUInteger, ESCErrorCode) {
    ESCErrorErrorCodeAccessDenied = 0,
    ESCErrorErrorCodeNoAccounts,
    ESCErrorErrorCodeUnableToParse,
};

@interface ESCError : NSError

+ (instancetype)errorWithCode:(ESCErrorCode)code localizedDescription:(NSString *)localizedDescription;
+ (instancetype)errorWithCode:(ESCErrorCode)code localizedDescription:(NSString *)localizedDescription underlyingError:(NSError *)underlyingError;

@end
