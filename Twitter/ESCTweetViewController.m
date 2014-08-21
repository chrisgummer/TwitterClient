//
//  ESCTweetViewController.m
//  Twitter
//
//  Created by Chris Gummer on 8/20/14.
//  Copyright (c) 2014 Effortless Code. All rights reserved.
//

#import "ESCTweetViewController.h"
#import "ESCTweetCell.h"
#import "ESCTweetViewModel.h"

@interface ESCTweetViewController ()
@property (strong, nonatomic) ESCTweetViewModel *viewModel;
@property (strong, nonatomic) ESCTweetCell *layoutCell;
@end

@implementation ESCTweetViewController

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.viewModel = [[ESCTweetViewModel alloc] init];
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTweetsIfPossible];
}


#pragma mark - Private

- (void)loadTweetsIfPossible {
    if (!self.refreshControl.refreshing) {
        [self loadTweets];
    }
}

- (void)loadTweets {
    [self.refreshControl beginRefreshing];
    [self.viewModel loadTweets:^(BOOL success, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!success) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.title", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK.title", nil) otherButtonTitles:nil] show];
            }
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }];
}

- (void)configureCell:(ESCTweetCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.viewModel = [self.viewModel tweetCellModelAtIndex:indexPath.row];
}


#pragma mark - Custom Accessors

- (ESCTweetCell *)layoutCell {
    if (!_layoutCell) {
        _layoutCell = [self.tableView dequeueReusableCellWithIdentifier:ESCTweetCellIdentifier];
    }
    return _layoutCell;
}


#pragma mark - Actions

- (IBAction)didChangeRefreshValue:(id)sender {
    [self loadTweets];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfTweets];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESCTweetCell *cell = (ESCTweetCell *)[tableView dequeueReusableCellWithIdentifier:ESCTweetCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.layoutCell atIndexPath:indexPath];
    [self.layoutCell layoutIfNeeded];
    
    CGSize size = [self.layoutCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    // account for separator
    return size.height + 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
