//
//  ESCTweetCellModel.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCTweetCellModel.h"
#import "ESCTweet.h"

@interface ESCTweetCellModel ()
@property (strong, nonatomic) ESCTweet *tweet;
@property (copy, nonatomic, readwrite) NSString *text;
@property (strong, nonatomic, readwrite) NSURL *profileImageURL;
@property (copy, nonatomic, readwrite) NSAttributedString *name;
@property (copy, nonatomic, readwrite) NSString *retweetName;
@end

@implementation ESCTweetCellModel

#pragma mark - Lifecycle

- (instancetype)initWithTweet:(ESCTweet *)tweet{
    self = [super init];
    if (self) {
        _tweet = tweet;
        _text = [tweet.text copy];
        _profileImageURL = tweet.profileImageURL;
        
        if (_tweet.retweetName) {
            _retweetName = [NSString stringWithFormat:NSLocalizedString(@"retweeted.format", nil), _tweet.retweetName];
        }
    }
    return self;
}


#pragma mark - Custom Accessors

- (NSAttributedString *)name {
    if (!_name) {
        NSDictionary *nameAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f] };
        NSMutableAttributedString *nameAttributedString = [[NSMutableAttributedString alloc] initWithString:self.tweet.name attributes:nameAttributes];
        NSDictionary *screenNameAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName : [UIColor lightGrayColor] };
        NSMutableAttributedString *screenNameAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" @%@", self.tweet.screenName] attributes:screenNameAttributes];
        [nameAttributedString appendAttributedString:screenNameAttributedString];
        _name = [nameAttributedString copy];
    }
    return _name;
}


#pragma mark - Public

- (void)downloadProfileImage:(ESCTweetCellModelDownloadCompletionHandler)completion {
    NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithRequest:[NSURLRequest requestWithURL:_profileImageURL] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!location) {
            completion(nil, error);
        } else {
            NSString *profileImagePath = [self permanentLocationForTemporaryLocation:location];
            UIImage *profileImage = [UIImage imageWithContentsOfFile:profileImagePath];
            completion(profileImage, nil);
        }
    }];
    [downloadTask resume];
}


#pragma mark - Private

- (NSString *)permanentLocationForTemporaryLocation:(NSURL *)temporaryLocation {
    NSParameterAssert(temporaryLocation);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths firstObject];
    NSString *permanentPath = [documentsPath stringByAppendingPathComponent:[temporaryLocation lastPathComponent]];
    
    [[NSFileManager defaultManager] moveItemAtPath:[temporaryLocation path] toPath:permanentPath error:nil];
    return permanentPath;
}

@end
