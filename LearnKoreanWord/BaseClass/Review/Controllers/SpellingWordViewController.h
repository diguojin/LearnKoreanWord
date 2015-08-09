//
//  SpellingWordViewController.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordList.h"
#import "SpellingWordView.h"

@interface SpellingWordViewController : UIViewController

@property (nonatomic, strong) WordList *wordList;

@property (nonatomic, strong) SpellingWordView *SWV;

@end
