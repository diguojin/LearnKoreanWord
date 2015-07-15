//
//  MyPageViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/28.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger totalMemWordsCount;

@property (nonatomic, strong) UIRefreshControl *pullDownRefreshControl;

@property (nonatomic, strong) DB *mydb;

@property (nonatomic, strong) UITableView *tableView;

@end
