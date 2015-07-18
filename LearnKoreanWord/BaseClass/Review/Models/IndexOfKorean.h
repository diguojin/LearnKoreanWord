//
//  IndexOfKorean.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/15.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexOfKorean : NSObject
@property (nonatomic, strong) NSArray *indexArray;

/**
 *  根据index,来返回一个韩语的序号
 *
 *  @param index 阿拉伯数字序号, 从0开始
 *
 *  @return 一个韩语字符串序号
 */
- (NSString *)KoreanIndexAtIndex:(NSInteger)index;

@end
