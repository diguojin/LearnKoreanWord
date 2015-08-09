//
//  SpellingWordView.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/22.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "SpellingWordView.h"

@implementation SpellingWordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.zhLabel];
        [self addSubview:self.inputKrTextField];
        [self addSubview:self.incorrectView];
        [self addSubview:self.correctView];
        [self addSubview:self.answerLabel];
    }
    
    return self;
}

- (UILabel *)zhLabel
{
    if (!_zhLabel) {
        _zhLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 100)];
        //_zhLabel.backgroundColor = [UIColor blueColor];
        _zhLabel.textAlignment = NSTextAlignmentCenter;
        _zhLabel.numberOfLines = 0;
        _zhLabel.text = @"韩国语";
        _zhLabel.textColor = COLOR_1;
        _zhLabel.font = [UIFont systemFontOfSize:40];
    }
    return _zhLabel;
}

- (UIView *)correctView
{
    if (!_correctView) {
        _correctView = [[UIView alloc]initWithFrame:CGRectMake(14, 170, 0, 4)];
        _correctView.backgroundColor = [UIColor greenColor];
    }
    
    return _correctView;
}

- (UIView *)incorrectView
{
    if (!_incorrectView) {
        _incorrectView = [[UIView alloc]initWithFrame:CGRectMake(14, 170, SCREEN_WIDTH - 28, 4)];
        _incorrectView.backgroundColor = [UIColor orangeColor];
    }
    
    return _incorrectView;
}

- (void)updateProgressWithRate:(double)rate
{
    self.correctView.frame = CGRectMake(self.correctView.frame.origin.x, self.correctView.frame.origin.y, rate*(SCREEN_WIDTH - 28), self.correctView.frame.size.height);
}

- (UITextField *)inputKrTextField
{
    if (!_inputKrTextField) {
        _inputKrTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 174, SCREEN_WIDTH - 20, 40)];
        _inputKrTextField.backgroundColor = [UIColor whiteColor];
        _inputKrTextField.placeholder = @"输入单词";
        _inputKrTextField.borderStyle = UITextBorderStyleRoundedRect;
        
    }
    
    return _inputKrTextField;
}


-(UILabel *)answerLabel
{
    if (!_answerLabel) {
        _answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 50)];
        //_answerLabel.backgroundColor = [UIColor redColor];
        _answerLabel.textAlignment = NSTextAlignmentCenter;
        _answerLabel.numberOfLines = 0;
        _answerLabel.hidden = YES;
    }
    return _answerLabel;
}

- (void)isCorrcet:(BOOL)correct
{
    if (correct) {
        _correctView.backgroundColor = [UIColor greenColor];
        return;
    }
    _correctView.backgroundColor = [UIColor redColor];
}

@end
