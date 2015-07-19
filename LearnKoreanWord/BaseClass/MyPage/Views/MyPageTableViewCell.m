//
//  MyPageTableViewCell.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/13.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "MyPageTableViewCell.h"
#import "UUChart.h"

@interface MyPageTableViewCell () <UUChartDataSource>
{
    UUChart *_chartView;
    NSIndexPath *_path;
}
@end

@implementation MyPageTableViewCell

- (void)setupChartViewWithIndexPath:(NSIndexPath *)indexPath
{
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    
    _chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 100)
                                               withSource:self
                                                withStyle:UUChartLineStyle];
    _path = indexPath;
    [_chartView showInView:self.contentView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (DB *)mydb
{
    if (!_mydb) {
        _mydb = [DB sharedDBWithName:kTargetDBFile];
    }
    return _mydb;
}

- (UIImageView *)iconImgView
{
    if (!_iconImgView) _iconImgView = [UIImageView new];
    return _iconImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) _titleLabel = [[UILabel alloc]init];
    return _titleLabel;
}

- (UILabel *)NumberLabel
{
    if (!_NumberLabel) _NumberLabel = [[UILabel alloc]init];
    return _NumberLabel;
}

#pragma -uuchart代理方法-
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart
{
    NSMutableArray *arr = [NSMutableArray new];
    
    NSDate *todayDate = [DB zeroOfDate];
    NSTimeInterval timeStamp = [todayDate timeIntervalSince1970];
    
    for (int i = 0; i < 5; i++) {
        [arr insertObject:[DB monthDayFormatWithTimeStamp:timeStamp] atIndex:0];
        timeStamp -= k1DaySeconds;
    }
    return arr;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart
{
    NSDate *todayDate = [DB zeroOfDate];
    NSTimeInterval timeStamp = [todayDate timeIntervalSince1970];
    NSMutableArray *arr = [NSMutableArray new];
    timeStamp += k1DaySeconds;
    for (int i = 0; i < 5; i++) {
        NSInteger wordsCount = [self.mydb getWordCountWithStartTimeStamp:timeStamp EndTime:(timeStamp - k1DaySeconds)];
        timeStamp -= k1DaySeconds;
        NSString *str = [NSString stringWithFormat:@"%ld", (long)wordsCount];
        [arr insertObject:str atIndex:0];
    }
    
    return @[arr];
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart
{
    return @[[UIColor orangeColor]];
}

//判断显示最大最小值
//- (BOOL)UUChart:(UUChart *)chart ShowMaxMinAtIndex:(NSInteger)index
//{
//    NSLog(@"-----%ld",index);
//    return YES;
//}

@end
