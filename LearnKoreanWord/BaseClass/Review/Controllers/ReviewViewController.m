//
//  ReviewViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/28.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewViewCell.h"
#import "ChapterWordListViewController.h"
#import "UILabel+FlickerNumber.h"

@interface ReviewViewController ()

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"复习";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:kReviewViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kReviewViewCell];
    [self.view addSubview:_tableView];
    _mydb = [DB sharedDBWithName:kTargetDBFile];
    _chaptersReviewedMArray = [_mydb getChapterInfoReviewed];
    
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)doRefresh
{
    _chaptersReviewedMArray = [_mydb getChapterInfoReviewed];
    [_tableView reloadData];
    [_refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_chaptersReviewedMArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReviewViewCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[ReviewViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReviewViewCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)[_chaptersReviewedMArray[indexPath.row] chapterId]];
    cell.titleLabel.text = [_mydb getBookNameByBookId:[_chaptersReviewedMArray[indexPath.row] bookId]];
    //cell.leftLabel.text = [NSString stringWithFormat:@"%.0f%%", 100*[_chaptersReviewedMArray[indexPath.row] rem_param]];
    [cell.leftLabel dd_setNumber:[NSNumber numberWithDouble:100*[_chaptersReviewedMArray[indexPath.row] rem_param]] format:@"%.0f%%"];
    //NSLog(@"%@", [NSString stringWithFormat:@"%.2f", [_chaptersReviewedMArray[indexPath.row] rem_param]]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChapterWordListViewController * CWVC = [[ChapterWordListViewController alloc]init];
    CWVC.chapterID = [_chaptersReviewedMArray[indexPath.row] chapterId];
    [self.navigationController pushViewController:CWVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
