//
//  ChapterViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/1.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "ChapterViewController.h"
#import "ChapterViewCell.h"
#import "ChapterWordListViewController.h"
#import "IndexOfKorean.h"

@interface ChapterViewController ()

@property (strong, nonatomic) IndexOfKorean *indexOfKr;

@end

@implementation ChapterViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        _chapterName = [[NSString alloc]init];
        _indexOfKr = [[IndexOfKorean alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"章节选择";
    DB *mydb = [DB sharedDBWithName:kTargetDBFile];
    _chaptersMArray = [[NSMutableArray alloc]init];
    _chaptersMArray = [mydb getChapterInfoByLexiconID:_lexiconID];
    
    [self.tableView registerNib:[UINib nibWithNibName:kChapterViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChapterViewCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_chaptersMArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterViewCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ChapterViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChapterViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.worldCountLabel.text = [NSString stringWithFormat:@"%ld", (long)[_chaptersMArray[indexPath.row] wordCount]];
    //cell.imgView.image = [UIImage imageNamed:@"chapter_img"];
    cell.LeftLabel.text = [_indexOfKr KoreanIndexAtIndex:indexPath.row];
    if ([_chaptersMArray[indexPath.row] isLearned] == 1) {
        cell.isLearnedLabel.hidden = NO;
    }else{
        cell.isLearnedLabel.hidden = YES;
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %ld", _chapterName, (long)indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapterWordListViewController * CWVC = [[ChapterWordListViewController alloc]init];
    CWVC.chapterID = [_chaptersMArray[indexPath.row] chapterId];

    NSLog(@"%ld",(long)[_chaptersMArray[indexPath.row] chapterId]);
    [self.navigationController pushViewController:CWVC animated:YES];
}
                            
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
