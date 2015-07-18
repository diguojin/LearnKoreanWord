//
//  Chapter.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/1.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Chapter : NSObject
@property (nonatomic, assign) NSInteger wordCount;
@property (nonatomic, assign) NSInteger chapterId;
@property (nonatomic, assign) NSInteger isLearned;
@property (nonatomic, assign) double rem_param;
@property (nonatomic, assign) NSInteger bookId;
@end
