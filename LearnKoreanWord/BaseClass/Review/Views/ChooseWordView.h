//
//  ChooseWordView.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigButtonView.h"
@protocol ChooseWordDelegate<NSObject>

@required
- (void)checkAnswer:(NSString *)answer;
@end

@interface ChooseWordView : UIView
@property (nonatomic, strong) UILabel *krWordLabel;

@property (nonatomic, weak) id<ChooseWordDelegate> delegate;

@property (nonatomic, strong) BigButtonView *btn1;
@property (nonatomic, strong) BigButtonView *btn2;
@property (nonatomic, strong) BigButtonView *btn3;
@property (nonatomic, strong) BigButtonView *btn4;

@end
