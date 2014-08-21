//
//  ESCTweet.h
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESCTweet : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *retweetName;
@property (copy, nonatomic, readonly) NSString *screenName;
@property (copy, nonatomic, readonly) NSString *retweetScreenName;
@property (copy, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) NSURL *profileImageURL;

- (instancetype)initWithTweetJSON:(NSDictionary *)tweetJSON;

@end
