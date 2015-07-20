//
//  DB.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/29.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "DB.h"
#import "Word.h"
@implementation DB

+ (instancetype) sharedDBWithName:(NSString *)DBName
{
    static DB *db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[self alloc] init];
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:DBName];
        db.fmdb = [FMDatabase databaseWithPath:dbpath];
    });
    return db;
}

/**
 *  更新词汇量
 *
 *  @param memCount   词汇记忆量
 */
- (void)updateMyWordsWithMemCount:(NSInteger)memCount
{
    [_fmdb open];
    
    FMResultSet *rs = [_fmdb executeQuery:@"SELECT * from my_words"];
    NSInteger memWordsCount = 0;
    while ([rs next]) {
//        NSLog(@"totalWordsCount:%d memWordsCount:%d",
//              [rs intForColumn:@"totalWordsCount"],
//              [rs intForColumn:@"memWordsCount"]);

        memWordsCount = [rs intForColumn:@"memWordsCount"];
    }
    
    [_fmdb executeUpdate:@"UPDATE my_words SET memWordsCount = ? WHERE id = 1", [NSNumber numberWithInteger: (memWordsCount + memCount)]];
    [_fmdb close];
}

/**
 *  更新词汇总量
 *
 *  @param totalCount 新增的词汇数
 */
- (void)updateMyWordsWithTotalCount:(NSInteger)totalCount
{
    [_fmdb open];
    
    FMResultSet *rs = [_fmdb executeQuery:@"SELECT * from my_words"];
    NSInteger totalWordsCount = 0;
    while ([rs next]) {
//        NSLog(@"totalWordsCount:%d memWordsCount:%d",
//              [rs intForColumn:@"totalWordsCount"],
//              [rs intForColumn:@"memWordsCount"]);
        
        totalWordsCount = [rs intForColumn:@"totalWordsCount"];
    }
    
    [_fmdb executeUpdate:@"UPDATE my_words SET totalWordsCount = ? WHERE id = 1", [NSNumber numberWithInteger: (totalWordsCount + totalCount)]];
    [_fmdb close];
}

/**
 *  获取所有词库
 *
 *  @return 所有词库对象的可变数组
 */
- (NSMutableArray *)getAllLexicon
{
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select * from lexicon"];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
//        NSLog(@"%d %@",
//              [rs intForColumn:@"ID"],
//              [rs stringForColumn:@"Lexicon"]);
        Lexicon *lexicon = [[Lexicon alloc]init];
        lexicon.lexicon = [rs stringForColumn:@"Lexicon"];
        lexicon.lexiconId = [rs intForColumn:@"ID"];
        lexicon.wordCount = [rs intForColumn:@"wordCount"];
        lexicon.lexiconDescription = [rs stringForColumn:@"description"];
        lexicon.imgName = [rs stringForColumn:@"imgName"];
        [arr addObject:lexicon];
    }
    [_fmdb close];
    return arr;
}

- (NSMutableArray *)getChapterInfoByLexiconID:(NSInteger)lexicionID
{
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as word_count, chapter, isLearned from word_list where bookId = ? group by chapter", [NSNumber numberWithInteger:lexicionID]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Chapter *chapter = [[Chapter alloc]init];
        chapter.wordCount = [rs intForColumn:@"word_count"];
        chapter.chapterId = [rs intForColumn:@"chapter"];
        chapter.isLearned = [rs intForColumn:@"isLearned"];
        [arr addObject:chapter];
    }
    [_fmdb close];
    return arr;
}


//获取单词列表信息
- (NSMutableArray *)getChapterWordList:(NSInteger)chapterID
{
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select * from word_list where chapter = ?", [NSNumber numberWithInteger:chapterID]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Word *word = [[Word alloc]init];
        word.zh = [rs stringForColumn:@"zh"];
        word.kr = [rs stringForColumn:@"kr"];
        word.wordId = [rs intForColumn:@"wid"];
        word.chapter = chapterID;
        [arr addObject:word];
    }
    [_fmdb close];
    return arr;
}


+ (void)setDBfileFromResourceFileName:(NSString *)fileName targetName:(NSString *)targetName
{
    //获取我的沙盒documents文件夹的路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSLog(@"%@",documentsPath);
    //生成我要生成的sqlitePath文件路径
    NSString *sqlitePath = [documentsPath stringByAppendingPathComponent:targetName];//@"my.sqlite"
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];//@"LKTDB.db"
//    NSLog(@"%@",bundleFilePath);

    if (![fileManager fileExistsAtPath:sqlitePath] && bundleFilePath) {
        //复制boundle中得sqlite文件复制到 沙盒的路径下
        [fileManager copyItemAtPath:bundleFilePath toPath:sqlitePath error:nil];
    }
}

//不重复制定范围随机数, 返回结果数组
//count : 需要的随机数的个数
//StartNum: 范围 ?(sNum) - ?(eNum)
+ (NSMutableArray *)randomArrayWithCount:(NSInteger)count StartNum:(NSInteger)sNum endNum:(NSInteger)eNum
{
    if (count > eNum) {
        return nil;
    }

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSInteger i = sNum; i < eNum; i++) {
        [arr addObject:[NSNumber numberWithInteger:i]];
    }
    
    if (count == eNum) {
        return arr;
    }
    
    NSMutableArray *randArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < count; i++) {
        NSInteger randomNum = arc4random() % eNum + sNum;
        if ([arr count] > randomNum && arr[randomNum]) {
            [randArr addObject:arr[randomNum]];
            [arr removeObjectAtIndex:randomNum];
        }else{
            i--;
        }
    }
    return randArr;
}


/**
 *  判断是否是已经是复习过的章节
 *
 *  @param chapter 章节编号
 *
 *  @return BOOL 是否
 */
- (BOOL)isChapterLearnedWithChapter:(NSInteger)chapter
{
    //select count(*)as word_count, chapter,isLearned from word_list where bookId = 1 group by chapter
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as word_count, chapter,isLearned from word_list where chapter = ? group by chapter", [NSNumber numberWithInteger:chapter]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Chapter *chapter = [[Chapter alloc]init];
        chapter.wordCount = [rs intForColumn:@"word_count"];
        chapter.chapterId = [rs intForColumn:@"chapter"];
        chapter.isLearned = [rs intForColumn:@"isLearned"];
        [arr addObject:chapter];
    }
    [_fmdb close];
    if ([arr[0] isLearned] == 1) {
        return YES;
    }
    return NO;
}


/**
 *  将指定的章节设置为已读
 *
 *  @param chapter 章节编号
 */
- (void)setChapterLearnedWithChapter:(NSInteger)chapter
{
    [_fmdb open];
    if (chapter) {
        [_fmdb executeUpdate:@"UPDATE word_list set isLearned = 1 where chapter = ?", [NSNumber numberWithInteger: chapter]];
    }
    [_fmdb close];
}

/**
 *  设置单词记忆率
 *
 *  @param chapter  章节编号
 *  @param memParam 记忆率
 */
- (void)setMemoryParamWidthChapter:(NSInteger)chapter MemParam:(double)memParam
{
    [_fmdb open];
    if (chapter && memParam) {
        
        NSTimeInterval timeStamp = [self getTimeStampNow];
        
//        NSLog(@"%ld", (long)timeStamp);
        
        [_fmdb executeUpdate:@"UPDATE word_list set rem_param = ? , createTime = ? where chapter = ?", [NSNumber numberWithDouble:memParam], [NSNumber numberWithInteger:timeStamp], [NSNumber numberWithInteger: chapter]];
    }
    [_fmdb close];
}

/**
 *  读取指定章节的单词记忆率
 *
 *  @param chapter 章节编号
 *
 *  @return 单词记忆率
 */
- (double)getMemoryParamWidthChapter:(NSInteger)chapter
{
    double memParam = 0.0;
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as word_count, chapter, isLearned, rem_param from word_list where chapter = ? group by chapter", [NSNumber numberWithInteger:chapter]];

    while ([rs next]) {
        memParam = [rs doubleForColumn:@"rem_param"];
    }
    [_fmdb close];
    return memParam;
}

/**
 *  增加单词错误次数1次
 *
 *  @param word 错误的单词
 */
- (void)addWordWrongTimesUpWithWord:(Word *)word
{
    [_fmdb open];
    if (word && word.wordId) {
        [_fmdb executeUpdate:@"UPDATE word_list SET wrongTimes = wrongTimes + 1 WHERE wid = ?", [NSNumber numberWithInteger:word.wordId]];
    }
    [_fmdb close];
}

/**
 *  减少单词错误次数1次
 *
 *  @param word 错误的单词
 */
- (void)reduceWordWrongTimesUpWithWord:(Word *)word
{
    [_fmdb open];
    if (word && word.wordId) {
        [_fmdb executeUpdate:@"UPDATE word_list SET wrongTimes = wrongTimes - 1 WHERE wid = ?", [NSNumber numberWithInteger:word.wordId]];
    }
    [_fmdb close];
}


/**
 *  制定某单词的错误次数
 *
 *  @param word  单词
 *  @param count 错误次数
 */
- (void)setWordWrongTimesUpWithWord:(Word *)word Count:(NSInteger)count
{
    [_fmdb open];
    if (word && word.wordId) {
        [_fmdb executeUpdate:@"UPDATE word_list SET wrongTimes = ? WHERE wid = ?", [NSNumber numberWithInteger:count], [NSNumber numberWithInteger:word.wordId]];
    }
    [_fmdb close];
}


/**
 *  获取记忆词汇量
 *
 *  @return 词汇记忆量
 */
- (NSInteger)getMyWordsMemWordsCount
{
    NSInteger memWordsCount = 0;
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"SELECT * from my_words"];
    while ([rs next]) {
        memWordsCount = [rs intForColumn:@"memWordsCount"];
    }
    [_fmdb close];
    return memWordsCount;
}


/**
 *  获取今天记忆词汇量
 *
 *  @return 今天词汇记忆量
 */
- (NSInteger)getMyTodayWordsMemWordsCount
{
    NSInteger todayMemWordsCount = 0;
    NSDate *todayZeroDate = [self zeroOfDate];
    //NSLog(@"%@", todayZeroDate);
    NSTimeInterval timeStamp = [todayZeroDate timeIntervalSince1970];
    //NSLog(@"%ld",(long) timeStamp);
    
    [_fmdb open];
    
    //FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as todayCount from word_list where createTime > ?", [NSNumber numberWithLong:(long)timeStamp]];
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as todayCount, rem_param from word_list where createTime > ? group by rem_param", [NSNumber numberWithLong:(long)timeStamp]];
    
    while ([rs next]) {
        double rem_param = [rs doubleForColumn:@"rem_param"];
        todayMemWordsCount += (NSInteger)([rs intForColumn:@"todayCount"] * rem_param);
    }
    
    [_fmdb close];
    return todayMemWordsCount;
}

- (NSMutableArray *)getChapterInfoReviewed
{
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as word_count, chapter, bookId, rem_param from word_list where isLearned = ? group by chapter order by rem_param asc", [NSNumber numberWithInteger:1]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Chapter *chapter = [[Chapter alloc]init];
        chapter.wordCount = [rs intForColumn:@"word_count"];
        chapter.chapterId = [rs intForColumn:@"chapter"];
        chapter.rem_param = [rs doubleForColumn:@"rem_param"];
        chapter.bookId = [rs intForColumn:@"bookId"];
        [arr addObject:chapter];
    }
    [_fmdb close];
    return arr;
}


/**
 *  根据BookId来获取词库名
 *
 *  @param bookId bookid
 *
 *  @return 词库名字符串
 */
- (NSString *)getBookNameByBookId:(NSInteger)bookId
{
    NSString *bookName = nil;
    if (bookId) {
        [_fmdb open];
        FMResultSet *rs = [_fmdb executeQuery:@"select * from lexicon where ID = ?", [NSNumber numberWithInteger:bookId]];
        while ([rs next]) {
            bookName = [rs stringForColumn:@"Lexicon"];
        }
        [_fmdb close];
    }
    return bookName;
}



/**
 *  根据时间(分钟)来计算艾宾浩斯记忆率
 *
 *  @param minute 时间(分钟)
 *
 *  @return 记忆率
 */
+ (double)getEbbinghausRemParamWithMinutes:(double)minute
{
    double rem_param = 1.0;

    if (minute >= 1) {
        double k = 4.8;
        double c = 1.2;
        rem_param = k / (pow(log(minute), c) + k);
    }

    return rem_param;
}

/**
 *  更新艾宾浩斯记忆率
 */
- (void)updateEbbinghausRemParam
{
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select * from word_list where isLearned = 1 group by chapter"];
    while ([rs next]) {
        NSTimeInterval passedTimeStamp = [rs doubleForColumn:@"createTime"];
        NSTimeInterval nowTimeStamp = [self getTimeStampNow];
        NSTimeInterval minutes = (nowTimeStamp - passedTimeStamp) / 60;
        //NSLog(@"time : %f", minutes);
        //读取更新前的记忆率
        //double oldRemParam = [rs doubleForColumn:@"rem_param"];
        
        
        //NSLog(@"过去了多少分钟 -- %.0f", minutes);
        double remParam = [DB getEbbinghausRemParamWithMinutes:minutes];
        
//#warning -计算上还是存在问题-
        //NSLog(@"艾宾浩斯记忆率%.2f * %.2f = %.2f", oldRemParam, remParam, newRemParam);
        NSInteger chapterId = [rs intForColumn:@"chapter"];

        [_fmdb executeUpdate:@"UPDATE word_list set rem_param = ? where chapter = ?", [NSNumber numberWithDouble:remParam], [NSNumber numberWithInteger: chapterId]];

    }
    [_fmdb close];
}

#pragma mark -时间戳相关-

/**
 *  获取以当前系统时间为准的时间戳
 *
 *  @return 时间戳
 */
- (NSTimeInterval)getTimeStampNow
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    
    NSDate *localDate = [date dateByAddingTimeInterval:interval];

    NSTimeInterval timeStamp = [localDate timeIntervalSince1970];

    return timeStamp;
}


/**
 *  获取当天00点时刻的日期对象, 时区是当前系统时区
 *
 *  @return 00点时刻的日起对象
 */
- (NSDate *)zeroOfDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    return localDate;
}

/**
 *  输入一个时间戳, 返回一个字符串的 月-日 的日期格式
 *
 *  @param timeStamp 时间戳
 *
 *  @return 月-日 的日期格式
 */
+ (NSString *)monthDayFormatWithTimeStamp:(NSTimeInterval)timeStamp
{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM-dd"];
    return [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
}

/**
 *  输入一个nsdate对象, 返回一个字符串的 月-日 的日期格式
 *
 *  @param nsdate 对象
 *
 *  @return 月-日 的日期格式
 */
+ (NSString *)monthDayFormatWithDate:(NSDate *)date
{
    NSString *todayDateString = [DB monthDayFormatWithTimeStamp: [date timeIntervalSince1970]];
    return todayDateString;
}

/**
 *  获取当天00点时刻的日期对象, 时区是当前系统时区
 *
 *  @return 00点时刻的日起对象
 */
+ (NSDate *)zeroOfDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    
    return localDate;
}


/**
 *  根据一个时间段返回期间复习过的单词数
 *
 *  @param startTime 起始时间戳
 *  @param endTime   结束时间戳
 *
 *  @return 复习过的单词数
 */
- (NSInteger)getWordCountWithStartTimeStamp:(NSTimeInterval)startTime EndTime:(NSTimeInterval)endTime
{
    //select count(*) as wordCount from word_list where createTime > 1436911210 and createTime < 1436911219
    NSInteger count = 0;
    if (startTime >= 0 && endTime >= 0) {
        if (startTime > endTime) {
            NSTimeInterval temp = startTime;
            startTime = endTime;
            endTime = temp;
        }
        
        [_fmdb open];
        FMResultSet *rs = [_fmdb executeQuery:@"select count(*) as wordCount from word_list where createTime > ? and createTime < ?", [NSNumber numberWithDouble:startTime], [NSNumber numberWithDouble:endTime]];
        while ([rs next]) {
            count = [rs intForColumn:@"wordCount"];
        }
        [_fmdb close];
    }
    return count;
}

/**
 *  获取全部错误过的单词
 *
 *  @return 错误单词数组
 */
- (NSMutableArray *)getAllWrongWords
{
    NSMutableArray *arr = [NSMutableArray new];
    [_fmdb open];
    FMResultSet *rs = [_fmdb executeQuery:@"select * from word_list where wrongTimes > 0 order by wrongTimes desc"];

    while ([rs next]) {
        Word *word = [Word new];
        word.wordId = [rs intForColumn:@"wid"];
        word.kr = [rs stringForColumn:@"kr"];
        word.zh = [rs stringForColumn:@"zh"];
        word.wrongTimes = [rs intForColumn:@"wrongTimes"];
        [arr addObject:word];
    }
    [_fmdb close];
    return arr;
}


@end
