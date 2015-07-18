//
//  ChapterViewCell.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/1.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *worldCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *LeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *isLearnedLabel;

@end
