//
//  LexiconViewCell.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/30.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LexiconViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordCountLabel;

@end
