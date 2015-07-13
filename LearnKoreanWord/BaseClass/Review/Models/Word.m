//
//  Word.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/2.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "Word.h"

@implementation Word
- (NSString *)description
{
    return [NSString stringWithFormat:@"kr:%@ zh:%@ wordId:%ld", self.kr, self.zh, (long)self.wordId];
}
@end
