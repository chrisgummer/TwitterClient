//
//  ESCTweet.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCTweet.h"

static NSString * const ESCTweetJSONKeyPathScreenName = @"user.screen_name";
static NSString * const ESCTweetJSONKeyPathName = @"user.name";
static NSString * const ESCTweetJSONKeyPathProfileImage = @"user.profile_image_url_https";
static NSString * const ESCTweetJSONKeyRetweetedStatus = @"retweeted_status";
static NSString * const ESCTweetJSONKeyText = @"text";

static NSString * const ESCTweetProfileImageURLSuffixNormal = @"_normal";
static NSString * const ESCTweetProfileImageURLSuffixBigger = @"_bigger";

@interface ESCTweet ()
@property (copy, nonatomic, readwrite) NSString *name;
@property (copy, nonatomic, readwrite) NSString *retweetName;
@property (copy, nonatomic, readwrite) NSString *screenName;
@property (copy, nonatomic, readwrite) NSString *retweetScreenName;
@property (copy, nonatomic, readwrite) NSString *text;
@property (strong, nonatomic, readwrite) NSURL *profileImageURL;
@end

@implementation ESCTweet

#pragma mark - Lifecycle

- (instancetype)initWithTweetJSON:(NSDictionary *)tweetJSON {
    self = [super init];
    if (self) {
        NSString *profileImageURLString;
        
        if (tweetJSON[ESCTweetJSONKeyRetweetedStatus]) {
            profileImageURLString = [tweetJSON[ESCTweetJSONKeyRetweetedStatus] valueForKeyPath:ESCTweetJSONKeyPathProfileImage];
            _text = [tweetJSON[ESCTweetJSONKeyRetweetedStatus][ESCTweetJSONKeyText] copy];
            _name = [[tweetJSON[ESCTweetJSONKeyRetweetedStatus] valueForKeyPath:ESCTweetJSONKeyPathName] copy];
            _retweetName = [[tweetJSON valueForKeyPath:ESCTweetJSONKeyPathName] copy];
            _screenName = [[tweetJSON[ESCTweetJSONKeyRetweetedStatus] valueForKeyPath:ESCTweetJSONKeyPathScreenName] copy];
            _retweetScreenName = [[tweetJSON valueForKeyPath:ESCTweetJSONKeyPathScreenName] copy];
        } else {
            profileImageURLString = [tweetJSON valueForKeyPath:ESCTweetJSONKeyPathProfileImage];
            _text = [tweetJSON[ESCTweetJSONKeyText] copy];
            _name = [[tweetJSON valueForKeyPath:ESCTweetJSONKeyPathName] copy];
            _screenName = [[tweetJSON valueForKeyPath:ESCTweetJSONKeyPathScreenName] copy];
        }
        _profileImageURL = [self URLForProfileImageURLString:profileImageURLString];
    }
    return self;
}


#pragma  mark - Private

- (NSURL *)URLForProfileImageURLString:(NSString *)profileImageURLString {
    if ([[[profileImageURLString lastPathComponent] stringByDeletingPathExtension] hasSuffix:ESCTweetProfileImageURLSuffixNormal]) {
        profileImageURLString = [profileImageURLString stringByReplacingOccurrencesOfString:ESCTweetProfileImageURLSuffixNormal withString:ESCTweetProfileImageURLSuffixBigger];
    }
    return [NSURL URLWithString:profileImageURLString];
}

@end
