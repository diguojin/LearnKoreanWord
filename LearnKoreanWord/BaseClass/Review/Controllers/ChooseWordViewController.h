//
//  ChooseWordViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordList.h"
#import "ChooseWordView.h"
@interface ChooseWordViewController : UIViewController<BigButtonDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WordList *wordList;

@property (nonatomic, strong) ChooseWordView *chooseWordView;

@property (nonatomic, strong) BigButtonView *btn1;
@property (nonatomic, strong) BigButtonView *btn2;
@property (nonatomic, strong) BigButtonView *btn3;
@property (nonatomic, strong) BigButtonView *btn4;

@end
