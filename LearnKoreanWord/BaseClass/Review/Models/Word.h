//
//  Word.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/2.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject
@property (nonatomic, strong) NSString *zh;
@property (nonatomic, strong) NSString *kr;
@property (nonatomic, assign) NSInteger wordId;
@property (nonatomic, assign) NSInteger chapter;
@end
