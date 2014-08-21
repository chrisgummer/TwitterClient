//
//  ESCTweetViewModel.h
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ESCTweetCellModel;

typedef void(^ESCTweetViewModelLoadCompletionHandler)(BOOL success, NSError *error);

@interface ESCTweetViewModel : NSObject

@property (assign, nonatomic, readonly) NSUInteger numberOfTweets;

- (void)loadTweets:(ESCTweetViewModelLoadCompletionHandler)completion;
- (ESCTweetCellModel *)tweetCellModelAtIndex:(NSUInteger)index;

@end
