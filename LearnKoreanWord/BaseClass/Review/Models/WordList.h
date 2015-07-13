//
//  WordList.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordList.h"
@interface WordList : NSObject

@property (nonatomic, strong) NSMutableArray *wordListMArray;
@property (nonatomic, strong) NSMutableArray *wrongWordsMArray;//记录错误单词
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger chapter;//章节编号

//下一个单词
- (NSInteger)nextWord;


//获取当前单词
- (Word *)getWord;

//获取单词列表中的单词数
- (NSInteger)count;

//随机答案
//返回包含正确答案的一个数组
- (NSMutableArray *)random4Kr;

//获取制定下表的单词
- (Word *)getWordAtIndex:(NSInteger)index;

//把当前单词记录为错误单词
- (void)addWrongWord;

//错误单词的数量
- (NSInteger)wrongCount;

//返回错误的单词
- (Word *)getWrongWordAtIndex:(NSInteger)index;

@end
