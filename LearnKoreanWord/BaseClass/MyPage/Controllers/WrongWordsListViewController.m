//
//  WrongWordsListViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/19.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "WrongWordsListViewController.h"
#import "WordListViewCell.h"

@interface WrongWordsListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *wrongWordsArray;

@property (nonatomic, strong) DB *mydb;

@end

@implementation WrongWordsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"错词单";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:kChapterWordListViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChapterWordListViewCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _mydb = [DB sharedDBWithName:kTargetDBFile];
    _wrongWordsArray = [_mydb getAllWrongWords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WordListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterWordListViewCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[WordListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChapterWordListViewCell];
    }
    cell.krLabel.text = [_wrongWordsArray[indexPath.row] kr];
    cell.zhLabel.text = [_wrongWordsArray[indexPath.row] zh];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_wrongWordsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWordListCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [_mydb setWordWrongTimesUpWithWord:_wrongWordsArray[indexPath.row] Count:0];
        [_wrongWordsArray removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
