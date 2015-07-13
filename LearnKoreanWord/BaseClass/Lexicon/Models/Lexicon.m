//
//  Lexicon.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/30.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "Lexicon.h"

@implementation Lexicon
- (instancetype)init{
    self = [super init];
    if (self) {
        _lexicon = [[NSString alloc]init];
        _imgName = [[NSString alloc]init];
        _lexiconDescription = [[NSString alloc]init];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
