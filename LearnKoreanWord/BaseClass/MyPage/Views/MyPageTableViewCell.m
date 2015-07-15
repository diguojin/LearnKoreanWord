//
//  MyPageTableViewCell.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/13.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "MyPageTableViewCell.h"

@implementation MyPageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)iconImgView
{
    if (!_iconImgView) _iconImgView = [UIImageView new];
    return _iconImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) _titleLabel = [[UILabel alloc]init];
    return _titleLabel;
}

- (UILabel *)NumberLabel
{
    if (!_NumberLabel) _NumberLabel = [[UILabel alloc]init];
    return _NumberLabel;
}

@end
