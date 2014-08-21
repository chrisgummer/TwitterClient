//
//  ESCTweetCell.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCTweetCell.h"
#import "ESCTweetCellModel.h"

NSString * const ESCTweetCellIdentifier = @"TweetCell";

@interface ESCTweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (strong, nonatomic) NSURL *profileImageURL;
@end

@implementation ESCTweetCell

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // TODO: this should be done as part of the image caching process, actually clipping the image as cornerRadius kills scrolling performance
    self.profileImageView.layer.cornerRadius = 5.0f;
    self.profileImageView.clipsToBounds = YES;
}


#pragma mark - Private

- (NSCache *)profileImageCache {
    static NSCache *ProfileImageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ProfileImageCache = [[NSCache alloc] init];
    });
    return ProfileImageCache;
}

- (void)reloadView {
    self.nameLabel.attributedText = self.viewModel.name;
    self.retweetNameLabel.text = self.viewModel.retweetName;
    self.profileImageURL = self.viewModel.profileImageURL;
    self.tweetTextLabel.text = self.viewModel.text;
}


#pragma mark - Custom Accessors

- (void)setViewModel:(ESCTweetCellModel *)viewModel {
    if (_viewModel != viewModel) {
        _viewModel = viewModel;
        
        [self reloadView];
    }
}

- (void)setProfileImageURL:(NSURL *)profileImageURL {
    if (_profileImageURL != profileImageURL) {
        _profileImageURL = profileImageURL;
        
        if (!_profileImageURL) {
            return;
        }
        
        NSString *cacheKey = [_profileImageURL absoluteString];
        UIImage *profileImage = [[self profileImageCache] objectForKey:cacheKey];
        if (!profileImage) {
            // TODO: ideally this would be a cancellable concurrent NSOperation that would be cancelled on prepareForReuse
            [self.viewModel downloadProfileImage:^(UIImage *image, NSError *error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [[self profileImageCache] setObject:image forKey:cacheKey];
                    
                    if ([[self.profileImageURL absoluteString] isEqualToString:cacheKey]) {
                        self.profileImageView.image = image;
                    }
                }];
            }];
        }
        
        self.profileImageView.image = profileImage;
    }
}

@end
