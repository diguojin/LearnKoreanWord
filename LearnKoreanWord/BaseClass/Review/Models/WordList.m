//
//  WordList.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "WordList.h"

@implementation WordList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _index = 0;
    }
    return self;
}

- (NSMutableArray *)wordListMArray
{
    if (!_wordListMArray) _wordListMArray = [[NSMutableArray alloc]init];
    return _wordListMArray;
}

- (NSMutableArray *)wrongWordsMArray
{
    if (!_wrongWordsMArray) _wrongWordsMArray = [[NSMutableArray alloc]init];
    return _wrongWordsMArray;
}

//返回当前单词列表中的单词个数
- (NSInteger)count
{
    return [_wordListMArray count];
}

//获取当前单词
- (Word *)getWord
{
    if (_index < [self count]) {
        return _wordListMArray[_index];
    }
    return nil;
}

- (Word *)getWordAtIndex:(NSInteger)index
{
    if (index < [self count]) {
        return _wordListMArray[index];
    }
    return nil;
}

- (Word *)getWrongWordAtIndex:(NSInteger)index
{
    if (index < [self wrongCount]) {
        return _wrongWordsMArray[index];
    }
    return nil;
}

//向下个单词移动, 如果是最后一个单词那么返回2
- (NSInteger)nextWord
{
    
    if (_index + 1 < [self count]) {
        _index ++;
        NSLog(@"%@", _wordListMArray[_index]);
        return 1;
    }else if (_index + 1 == [self count])
    {
        return 2;
    }
    return 0;
}

//返回包含正确答案的一个数组
- (NSMutableArray *)random4Kr
{
    NSInteger count = [_wordListMArray count];
    if (count > 4) {
        NSMutableArray *randomNumArray = [DB randomArrayWithCount:4 StartNum:0 endNum:count];
        if (![randomNumArray containsObject:[NSNumber numberWithInteger:_index]]) {
            randomNumArray[arc4random()%4] = [NSNumber numberWithInteger:_index];
        }
        for (NSNumber *nb in randomNumArray) {
            NSLog(@"%@", nb);
        }
        return randomNumArray;
    }
    return nil;
}

//把当前单词记录为错误单词
- (void)addWrongWord
{
    [self.wrongWordsMArray addObject:self.wordListMArray[self.index]];
}

//错误单词的数量
- (NSInteger)wrongCount
{
    return [self.wrongWordsMArray count];
}

@end
