//
//  BigButtonView.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BigButtonDelegate<NSObject>

@required

//检查答案正确与否
- (void)checkAnswer:(NSString *)answer;

@end

@interface BigButtonView : UILabel

@property (nonatomic, weak) id<BigButtonDelegate> delegate;

@end
