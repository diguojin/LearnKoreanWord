//
//  ReviewViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/28.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *chaptersReviewedMArray;

@property (nonatomic, strong) DB *mydb;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
