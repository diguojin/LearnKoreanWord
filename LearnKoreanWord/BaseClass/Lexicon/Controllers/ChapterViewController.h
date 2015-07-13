//
//  ChapterViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/1.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterViewController : UITableViewController
@property (nonatomic, assign) NSInteger lexiconID;

@property (nonatomic, strong) NSMutableArray *chaptersMArray;

@property (nonatomic, strong) NSString *chapterName;

@end
