//
//  ESCTweetViewModelTests.m
//  Twitter
//
//  Created by Chris Gummer on 8/21/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ESCTweetViewModel.h"
#import "ESCTweet.h"

@interface ESCTweetViewModel (TestSupport)
- (NSArray *)tweetsFromJSONData:(NSData *)JSONData error:(NSError **)error;
@end

@interface ESCTweetViewModelTests : XCTestCase
@property (strong, nonatomic) ESCTweetViewModel *viewModel;
@end

@implementation ESCTweetViewModelTests

#pragma mark - Lifecycle

- (void)setUp {
    [super setUp];
    self.viewModel = [[ESCTweetViewModel alloc] init];
}

- (void)tearDown {
    [super tearDown];
    self.viewModel = nil;
}


#pragma mark - Tests

- (void)testTweetsFromJSONData {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"ESCTimeLineResponse" ofType:@"json"];
    NSData *JSONData = [NSData dataWithContentsOfFile:path];
    NSArray *tweets = [self.viewModel tweetsFromJSONData:JSONData error:nil];
    ESCTweet *firstTweet = [tweets firstObject];
    
    XCTAssertEqual([tweets count], 25, @"Should have 25 tweets");
    XCTAssertEqualObjects(firstTweet.screenName, @"robinwilliams", @"Screen name should be robinwilliams for first tweet");
    XCTAssertEqualObjects(firstTweet.text, @"#tbt and Happy Birthday to Ms. Zelda Rae Williams!    Quarter of a century old today but always my… http://t.co/qlsWIu429e", @"Text incorrect");
    XCTAssertNil(firstTweet.retweetScreenName, @"Should not have any retweeted information");
    XCTAssertNil(firstTweet.retweetName, @"Should not have any retweeted information");
}

@end
