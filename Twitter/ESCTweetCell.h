//
//  ESCTweetCell.h
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESCTweetCellModel;

FOUNDATION_EXPORT NSString * const ESCTweetCellIdentifier;

@interface ESCTweetCell : UITableViewCell

@property (strong, nonatomic) ESCTweetCellModel *viewModel;

@end
