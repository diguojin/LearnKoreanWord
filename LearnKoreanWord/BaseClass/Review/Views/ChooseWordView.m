//
//  ChooseWordView.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "ChooseWordView.h"

@implementation ChooseWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CGFloat baseY = SCREEN_HEIGHT / 2 ;
//        CGFloat baseWidth = SCREEN_WIDTH / 2;
//        CGFloat baseHeight = ((SCREEN_HEIGHT / 2 ) - 49 ) / 2;
//        
//        self.userInteractionEnabled = YES;
//        
//        _btn1 = [[BigButtonView alloc]initWithFrame:CGRectMake(0, baseY, 0, baseHeight)];
//        [self addSubview:_btn1];
//        _btn1.backgroundColor = COLOR_1;
//        _btn1.userInteractionEnabled = YES;
//        
//        _btn2 = [[BigButtonView alloc]initWithFrame:CGRectMake(baseWidth, baseY, 0, baseHeight)];
//        _btn2.backgroundColor  = COLOR_2;
//        [self addSubview:_btn2];
//        
//        _btn3 = [[BigButtonView alloc]initWithFrame:CGRectMake(0, baseY + _btn1.frame.size.height, 0, baseHeight)];
//        _btn3.backgroundColor  = COLOR_3;
//        [self addSubview:_btn3];
//        
//        _btn4 = [[BigButtonView alloc]initWithFrame:CGRectMake(baseWidth, baseY + _btn3.frame.size.height, 0, baseHeight)];
//        _btn4.backgroundColor  = COLOR_4;
//        [self addSubview:_btn4];
        
        
#pragma mark-单词-
        
        _krWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100)];
        _krWordLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:_krWordLabel];
        _krWordLabel.text = @"한국어";
        //_krWordLabel.textColor = [UIColor colorWithRed:147/255.0 green:224/255.0 blue:255.0 alpha:1];
        _krWordLabel.font = [UIFont systemFontOfSize:32];
        _krWordLabel.textAlignment = NSTextAlignmentCenter;
                        
                        
    }
    return self;
}

- (void)tapAction:(UIGestureRecognizer *)tap
{
    NSLog(@"tapAction");
}

@end
