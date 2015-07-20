//
//  BigButtonView.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "BigButtonView.h"

@implementation BigButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, SCREEN_WIDTH / 2, frame.size.height);
        self.backgroundColor = [UIColor greenColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"wojiukankan";
        self.userInteractionEnabled = YES;
        self.numberOfLines = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)tap
{
    if(_delegate && [_delegate respondsToSelector:@selector(checkAnswer:)]){
        [_delegate checkAnswer:self.text];
    }
}

@end
