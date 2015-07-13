//
//  Lexicon.h
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/30.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lexicon : NSObject
@property (nonatomic, assign) NSInteger lexiconId;
@property (nonatomic, assign) NSInteger wordCount;

@property (nonatomic, strong) NSString *lexicon;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) NSString *lexiconDescription;

@end
