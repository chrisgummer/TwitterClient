//
//  ESCTweetViewModel.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCTweetViewModel.h"
#import "ESCTweet.h"
#import "ESCTweetCellModel.h"
#import "ESCError.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

static NSString * const ESCTweetViewModelTimeLineURLString = @"https://api.twitter.com/1.1/statuses/home_timeline.json?count=25";

@interface ESCTweetViewModel ()
@property (strong, nonatomic) NSArray *tweets;
@end

@implementation ESCTweetViewModel

#pragma mark - Public

- (void)loadTweets:(ESCTweetViewModelLoadCompletionHandler)completion {
    NSParameterAssert(completion);
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        ACAccount *account;
        if (!granted) {
            NSError *error = [ESCError errorWithCode:ESCErrorErrorCodeAccessDenied localizedDescription:NSLocalizedString(@"error.access", nil)];
            completion(NO, error);
            return;
        }
        NSArray *accounts = [accountStore accountsWithAccountType:accountType];
        account = [accounts firstObject];
        
        if (!account) {
            NSError *error = [ESCError errorWithCode:ESCErrorErrorCodeNoAccounts localizedDescription:NSLocalizedString(@"error.account", nil)];
            completion(NO, error);
            return;
        }
        
        [self loadTweetsForAccount:account completion:completion];
     }];
}

- (ESCTweetCellModel *)tweetCellModelAtIndex:(NSUInteger)index {
    ESCTweet *tweet = self.tweets[index];
    ESCTweetCellModel *viewModel = [[ESCTweetCellModel alloc] initWithTweet:tweet];
    return viewModel;
}


#pragma mark - Private

- (void)loadTweetsForAccount:(ACAccount *)account completion:(ESCTweetViewModelLoadCompletionHandler)completion {
    // TODO: potentially wrap these in a concurrent NSOperation so we can route than through an NSOperationQueue to throttle how many we have in flight
    // Currently the UI is providing the throttling
    NSParameterAssert(account);
    NSParameterAssert(completion);
    NSURL *timelineURL = [NSURL URLWithString:ESCTweetViewModelTimeLineURLString];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:timelineURL parameters:nil];
    request.account = account;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!responseData || urlResponse.statusCode != 200) {
            error = [ESCError errorWithCode:ESCErrorErrorCodeUnableToParse localizedDescription:NSLocalizedString(@"error.parse", nil) underlyingError:error];
            completion(NO, error);
            return;
        }
        self.tweets = [self tweetsFromJSONData:responseData error:&error];
        if (!self.tweets) {
            completion(NO, error);
        } else {
            completion(YES, nil);
        }
    }];
}

- (NSArray *)tweetsFromJSONData:(NSData *)JSONData error:(NSError **)error {
    NSError *parseError;
    NSArray *tweetsJSONArray = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&parseError];
    if (!tweetsJSONArray) {
        *error = [ESCError errorWithCode:ESCErrorErrorCodeUnableToParse localizedDescription:NSLocalizedString(@"error.parse", nil) underlyingError:parseError];
        return nil;
    }
    
    NSMutableArray *tweets = [NSMutableArray array];
    [tweetsJSONArray enumerateObjectsUsingBlock:^(NSDictionary *tweetJSON, NSUInteger idx, BOOL *stop) {
        [tweets addObject:[[ESCTweet alloc] initWithTweetJSON:tweetJSON]];
    }];
    return [tweets copy];
}


#pragma mark - Custom Accessors

- (NSUInteger)numberOfTweets {
    return [self.tweets count];
}

@end
