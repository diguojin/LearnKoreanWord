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
        NSLog(@"totalWordsCount:%d memWordsCount:%d",
              [rs intForColumn:@"totalWordsCount"],
              [rs intForColumn:@"memWordsCount"]);

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
        NSLog(@"totalWordsCount:%d memWordsCount:%d",
              [rs intForColumn:@"totalWordsCount"],
              [rs intForColumn:@"memWordsCount"]);
        
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
        NSLog(@"%d %@",
              [rs intForColumn:@"ID"],
              [rs stringForColumn:@"Lexicon"]);
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
    FMResultSet *rs = [_fmdb executeQuery:@"select count(*)as word_count, chapter from word_list where bookId = ? group by chapter", [NSNumber numberWithInteger:lexicionID]];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while ([rs next]) {
        Chapter *chapter = [[Chapter alloc]init];
        chapter.wordCount = [rs intForColumn:@"word_count"];
        chapter.chapterId = [rs intForColumn:@"chapter"];
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
    NSLog(@"%@",documentsPath);
    //生成我要生成的sqlitePath文件路径
    NSString *sqlitePath = [documentsPath stringByAppendingPathComponent:targetName];//@"my.sqlite"
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];//@"LKTDB.db"
    NSLog(@"%@",bundleFilePath);

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
        [_fmdb executeUpdate:@"UPDATE word_list set rem_param = ? where chapter = ?", [NSNumber numberWithDouble:memParam], [NSNumber numberWithInteger: chapter]];
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

@end
