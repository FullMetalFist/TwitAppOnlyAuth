//
//  ViewController.m
//  TwitAppOnlyAuth
//
//  Created by Michael Vilabrera on 5/12/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "ViewController.h"
#import <STTwitter/STTwitter.h>
#import "Constants.h"

NSString *const CellIdentifier = @"CellID";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *twitterFeed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createViews];
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY consumerSecret:TWITTER_CONSUMER_SECRET];
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        //
        [twitter getUserTimelineWithScreenName:@"mvilabrera" successBlock:^(NSArray *statuses) {
            //
            self.twitterFeed = [NSMutableArray arrayWithArray:statuses];
            [self.tableView reloadData];
        } errorBlock:^(NSError *error) {
            //
            NSLog(@"Error: %@", error.debugDescription);
        }];
    } errorBlock:^(NSError *error) {
        //
        NSLog(@"Error: %@", error.debugDescription);
    }];
}

- (void)createViews
{
    CGRect tableViewFrame = CGRectMake(30, 30, 300, 500);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark -- TableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.twitterFeed.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger idx = indexPath.row;
    NSDictionary *t = self.twitterFeed[idx];
    cell.textLabel.text = t[@"text"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when you tap the cell, it will deselect right away (just because)
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
