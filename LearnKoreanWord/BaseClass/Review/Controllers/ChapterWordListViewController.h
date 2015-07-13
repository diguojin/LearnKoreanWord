//
//  ChapterWordListViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/2.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterWordListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger chapterID;

@property (nonatomic, strong) NSMutableArray *wordListMArray;

@property (nonatomic, strong) UITableView *tableView;

@end
