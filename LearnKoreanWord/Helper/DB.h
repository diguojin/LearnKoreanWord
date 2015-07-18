//
//  DB.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/29.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "Lexicon.h"
#import "Chapter.h"


@interface DB : NSObject

@property (nonatomic, strong) FMDatabase * fmdb;

+ (void)setDBfileFromResourceFileName:(NSString *)fileName targetName:(NSString *)targetName;

+ (instancetype) sharedDBWithName:(NSString *)DBName;

- (NSMutableArray *)getAllLexicon;

/**
 *  根据词库ID来获取词库下所有章节信息
 *
 *  @param lexicionID 词库ID
 *
 *  @return 章节信息数组
 */
- (NSMutableArray *)getChapterInfoByLexiconID:(NSInteger)lexicionID;

/**
 *  根据章节编号获取章节的单词列表
 *
 *  @param chapterID 章节编号
 *
 *  @return 由单词组成的可变数组
 */
- (NSMutableArray *)getChapterWordList:(NSInteger)chapterID;

//不重复制定范围随机数, 返回结果数组
//count : 需要的随机数的个数
//StartNum: 范围 ?(sNum) - ?(eNum)
/**
 *  不重复制定范围随机数, 返回结果数组
 *
 *  @param count 需要的随机数的个数
 *  范围 ?(sNum) - ?(eNum)
 *  @param sNum  最小数
 *  @param eNum  最大数
 *
 *  @return 随机数组成的数组
 */
+ (NSMutableArray *)randomArrayWithCount:(NSInteger)count StartNum:(NSInteger)sNum endNum:(NSInteger)eNum;

/**
 *  更新词汇量
 *
 *  @param memCount   词汇记忆量
 */
- (void)updateMyWordsWithMemCount:(NSInteger)memCount;

/**
 *  判断是否是已经是复习过的章节
 *
 *  @param chapter 章节编号
 *
 *  @return BOOL 是否
 */
- (BOOL)isChapterLearnedWithChapter:(NSInteger)chapter;

/**
 *  将指定的章节设置为已读
 *
 *  @param chapter 章节编号
 */
- (void)setChapterLearnedWithChapter:(NSInteger)chapter;

/**
 *  更新词汇总量
 *
 *  @param totalCount 新增的词汇数
 */
- (void)updateMyWordsWithTotalCount:(NSInteger)totalCount;

/**
 *  设置单词记忆率
 *
 *  @param chapter  章节编号
 *  @param memParam 记忆率
 */
- (void)setMemoryParamWidthChapter:(NSInteger)chapter MemParam:(double)memParam;

/**
 *  读取指定章节的单词记忆率
 *
 *  @param chapter 章节编号
 *
 *  @return 单词记忆率
 */
- (double)getMemoryParamWidthChapter:(NSInteger)chapter;

/**
 *  获取记忆词汇量
 *
 *  @return 词汇记忆量
 */
- (NSInteger)getMyWordsMemWordsCount;

/**
 *  获取今天记忆词汇量
 *
 *  @return 今天词汇记忆量
 */
- (NSInteger)getMyTodayWordsMemWordsCount;

/**
 *  获取已经复习了章节
 *
 *  @return 返回章节数组
 */
- (NSMutableArray *)getChapterInfoReviewed;

/**
 *  根据BookId来获取词库名
 *
 *  @param bookId bookid
 *
 *  @return 词库名字符串
 */
- (NSString *)getBookNameByBookId:(NSInteger)bookId;

/**
 *  根据时间(分钟)来计算艾宾浩斯记忆率
 *
 *  @param minute 时间(分钟)
 *
 *  @return 记忆率
 */
+ (double)getEbbinghausRemParamWithMinutes:(double)minute;

/**
 *  更新艾宾浩斯记忆率
 */
- (void)updateEbbinghausRemParam;

/**
 *  获取当天00点时刻的日期对象, 时区是当前系统时区
 *
 *  @return 00点时刻的日起对象
 */
+ (NSDate *)zeroOfDate;

/**
 *  输入一个时间戳, 返回一个字符串的 月-日 的日期格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 月-日 的日期格式
 */
+ (NSString *)monthDayFormatWithTimeStamp:(NSTimeInterval)timeStamp;

/**
 *  输入一个nsdate对象, 返回一个字符串的 月-日 的日期格式
 *
 *  @param nsdate 对象
 *
 *  @return 月-日 的日期格式
 */
+ (NSString *)monthDayFormatWithDate:(NSDate *)date;

/**
 *  根据一个时间段返回期间复习过的单词数
 *
 *  @param startTime 起始时间戳
 *  @param endTime   结束时间戳
 *
 *  @return 复习过的单词数
 */
- (NSInteger)getWordCountWithStartTimeStamp:(NSTimeInterval)startTime EndTime:(NSTimeInterval)endTime;

@end
