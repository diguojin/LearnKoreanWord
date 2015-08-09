//
//  SpellingWordView.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/22.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpellingWordView : UIView

@property (nonatomic, strong) UILabel *zhLabel;

@property (nonatomic, strong) UIView *correctView;
@property (nonatomic, strong) UIView *incorrectView;

@property (nonatomic, strong) UITextField *inputKrTextField;

@property (nonatomic, strong) UILabel *answerLabel;

/**
 *  根据正确与否显示相应地颜色, 正确:绿色, 错误:红色
 *
 *  @param correct 是否正确
 */
- (void)isCorrcet:(BOOL)correct;

/**
 *  根据rate修改进度条长度
 *
 *  @param rate 完成率
 */
- (void)updateProgressWithRate:(double)rate;

@end
