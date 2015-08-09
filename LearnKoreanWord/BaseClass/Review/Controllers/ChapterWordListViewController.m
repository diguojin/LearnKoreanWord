//
//  ChapterWordListViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/2.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "ChapterWordListViewController.h"
#import "Word.h"
#import "WordListViewCell.h"
#import "BigButtonView.h"
#import "ChooseWordViewController.h"
#import "SpellingWordViewController.h"

@interface ChapterWordListViewController ()

@end

@implementation ChapterWordListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _wordListMArray = [[NSMutableArray alloc]init];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 59) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.title = @"单词清单";
    DB * mydb = [DB sharedDBWithName:kTargetDBFile];
    _wordListMArray = [mydb getChapterWordList:_chapterID];
    [self.tableView registerNib:[UINib nibWithNibName:kChapterWordListViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChapterWordListViewCell];
    
    
#pragma mark-单词按钮-
    BigButtonView *leftBtn = [[BigButtonView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 109, 0, 60)];
    [self.view addSubview:leftBtn];
    leftBtn.backgroundColor = COLOR_1;
    leftBtn.text = @"开始回忆";
    leftBtn.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToStartMemory)];
    [leftBtn addGestureRecognizer:leftTap];
    leftBtn.frame = CGRectMake(leftBtn.frame.origin.x, leftBtn.frame.origin.y, SCREEN_WIDTH / 2, leftBtn.frame.size.height);
    
    
    BigButtonView *rightBtn = [[BigButtonView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 109, 0, 60)];
    [self.view addSubview:rightBtn];
    rightBtn.text = @"开始拼写";
    rightBtn.userInteractionEnabled = YES;
    rightBtn.backgroundColor = COLOR_2;
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToStartReview)];
    [rightBtn addGestureRecognizer:rightTap];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToStartMemory
{
    ChooseWordViewController *CWVC = [[ChooseWordViewController alloc]init];
    CWVC.wordList.wordListMArray = _wordListMArray;
    CWVC.wordList.chapter = [_wordListMArray[0] chapter];
    [self.navigationController pushViewController:CWVC animated:YES];
}

- (void)pushToStartReview
{
    SpellingWordViewController *SWVC = [[SpellingWordViewController alloc]init];
    SWVC.wordList.wordListMArray = _wordListMArray;
    SWVC.wordList.chapter = [_wordListMArray[0] chapter];
    [self.navigationController pushViewController:SWVC animated:YES];
    //NSLog(@"开始复习");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_wordListMArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WordListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterWordListViewCell forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[WordListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChapterWordListViewCell];
    }
    cell.krLabel.text = [_wordListMArray[indexPath.row] kr];
    cell.zhLabel.text = [_wordListMArray[indexPath.row] zh];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWordListCellHeight;
}

@end
