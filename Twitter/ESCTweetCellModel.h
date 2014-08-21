//
//  ESCTweetCellModel.h
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCTweet;

typedef void(^ESCTweetCellModelDownloadCompletionHandler)(UIImage *image, NSError *error);

@interface ESCTweetCellModel : NSObject

@property (copy, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) NSURL *profileImageURL;
@property (copy, nonatomic, readonly) NSAttributedString *name;
@property (copy, nonatomic, readonly) NSString *retweetName;

- (instancetype)initWithTweet:(ESCTweet *)tweet;
- (void)downloadProfileImage:(ESCTweetCellModelDownloadCompletionHandler)completion;

@end
