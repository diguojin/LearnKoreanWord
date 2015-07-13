//
//  LexiconViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/30.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "LexiconViewController.h"
#import "LexiconViewCell.h"
#import "ChapterViewController.h"

@interface LexiconViewController ()

@end

@implementation LexiconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:kLexiconViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kLexiconViewCell];
    
    self.title = @"词库";
    [DB setDBfileFromResourceFileName:kResourceDBFile targetName:kTargetDBFile];
    DB * mydb = [DB sharedDBWithName:kTargetDBFile];
    _lexiconsMArray = [[NSMutableArray alloc]init];
    _lexiconsMArray = [mydb getAllLexicon];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_lexiconsMArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LexiconViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLexiconViewCell];
    if (cell == nil) {
        cell = [[LexiconViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [_lexiconsMArray[indexPath.row] lexicon];
    cell.wordCountLabel.text = [NSString stringWithFormat:@"单词数: %ld", (long)[_lexiconsMArray[indexPath.row] wordCount] ];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width * 0.5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)[_lexiconsMArray[indexPath.row] lexiconId]);
    ChapterViewController *CVC = [[ChapterViewController alloc]init];
    CVC.lexiconID = [_lexiconsMArray[indexPath.row] lexiconId];
    CVC.chapterName = [_lexiconsMArray[indexPath.row] lexicon];
    [self.navigationController pushViewController:CVC animated:YES];
}

@end
