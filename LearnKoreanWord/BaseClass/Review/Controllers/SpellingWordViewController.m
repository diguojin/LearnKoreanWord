//
//  SpellingWordViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "SpellingWordViewController.h"
#import "SpellingWordView.h"
#import "ChooseWordViewController.h"
#import "CRGradientLabel.h"
#import "WordListViewCell.h"

@interface SpellingWordViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SpellingWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _SWV = [[SpellingWordView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_SWV];
    self.title = @"开始拼写";
    self.view.backgroundColor = [UIColor whiteColor];

    [_SWV.inputKrTextField addTarget:self action:@selector(editingInputKrTextField) forControlEvents:UIControlEventEditingChanged];
    _SWV.zhLabel.text = [[_wordList getWord] zh];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"答案" style:UIBarButtonItemStyleDone target:self action:@selector(showAnswer)];
    _SWV.answerLabel.text = [[_wordList getWord] kr];
    
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editingInputKrTextField
{
    //NSLog(@"改为, %@", _SWV.inputKrTextField.text);
    
    [self checkAnswer:_SWV.inputKrTextField.text];
    
    //NSLog(@"%d / %d", [_SWV.inputKrTextField.text length] , (unsigned long)[[[_wordList getWord] kr] length]);
    [_SWV updateProgressWithRate:[_SWV.inputKrTextField.text length] / (double)[[[_wordList getWord] kr] length]];
}


- (void)showAnswer
{
    //NSLog(@"显示答案");
    _SWV.answerLabel.hidden = NO;
}

//判断答案是否正确
- (void)checkAnswer:(NSString *)answer
{
    //NSLog(@"我提交的答案是%@",answer);
    if ([answer isEqualToString:[[_wordList getWord] kr]]) {
        //NSLog(@"回答正确%@",answer);
        
        NSInteger result = [_wordList nextWord];
        if (result == 2) {
            //NSLog(@"单元结束");
            [self finishChapter];
        }else{
            [self showAnswerHUDIsCorrect:YES];
        }
        [self updateUI];
        
    }
}

//更新视图数据
- (void)updateUI
{
    _SWV.inputKrTextField.text = @"";
    _SWV.zhLabel.text = [[_wordList getWord] zh];
    _SWV.answerLabel.text = [[_wordList getWord] kr];
    _SWV.answerLabel.hidden = YES;
}

/**
 *  单元结束
 */
- (void)finishChapter
{
    DB *mydb = [DB sharedDBWithName:kTargetDBFile];
    //此章节状态修改为已经复习
    NSInteger chapterId = _wordList.chapter;
    if (chapterId != 0) {
        if (![mydb isChapterLearnedWithChapter:chapterId]) {
            //增加单词总量
            [mydb updateMyWordsWithTotalCount:[_wordList count]];
            //将章节学习状态改为已经学习
            [mydb setChapterLearnedWithChapter:chapterId];
        }
    }
    
    double newMemParam = 0;
    if([_wordList count] != 0){
        
        //记住的单词数
        NSInteger wordsCountRemembered = [_wordList count] - [_wordList wrongCount];
        
        //获取之前的记忆率
        double memParam = [mydb getMemoryParamWidthChapter:chapterId];
        //NSLog(@"当前单词记忆率: %f", memParam);
        
        //根据之前的记忆率来修正即将更新的单词记忆量
        NSInteger wordsCountWillUpdate = wordsCountRemembered - [_wordList count] * memParam;
        
        //更新记忆的单词量
        [mydb updateMyWordsWithMemCount:wordsCountWillUpdate];
        
        //更新单词记忆率
        newMemParam = wordsCountRemembered / (double)[_wordList count];
        
        [mydb setMemoryParamWidthChapter:chapterId MemParam: newMemParam];
        //NSLog(@"更新后的单词记忆率: %f", newMemParam);
        
        //给错误单词 进行错误次数计数
        if ([_wordList wrongCount] > 0) {
            for (Word *wrongWord in _wordList.wrongWordsMArray) {
                [mydb addWordWrongTimesUpWithWord:wrongWord];
            }
        }
    }
    
    [self showResult];
    if (newMemParam == 1.000000) {
        [self showAnswerFinishHUDAllIsCorrect:YES];
    }else{
        [self showAnswerFinishHUDAllIsCorrect:NO];
    }
}

- (void)showResult
{
    UITableView *resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    resultTableView.backgroundColor = [UIColor whiteColor];
    resultTableView.delegate = self;
    resultTableView.dataSource = self;
    resultTableView.sectionHeaderHeight = 0;
    [resultTableView registerNib:[UINib nibWithNibName:kChapterWordListViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kChapterWordListViewCell];
    [self.view addSubview:resultTableView];
}

- (WordList *)wordList
{
    if (!_wordList) _wordList = [[WordList alloc]init];;
    return _wordList;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wordList wrongCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WordListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterWordListViewCell];
    if (cell == nil) {
        cell = [[WordListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChapterWordListViewCell];
    }
    Word *wrongWord = [_wordList getWrongWordAtIndex:indexPath.row];
    cell.krLabel.text = [wrongWord kr];
    cell.zhLabel.text = [wrongWord zh];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CRGradientLabel *colorLabel = [[CRGradientLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWordListHeaderHeight -10)];
    colorLabel.gradientColors = @[[UIColor redColor],[UIColor orangeColor]];
    NSInteger wordCount = [_wordList count];
    NSInteger wrongCount = [_wordList wrongCount];
    colorLabel.text = [NSString stringWithFormat:@"词汇量 +%ld",(long)(wordCount - wrongCount)];
    colorLabel.font = [UIFont systemFontOfSize:35];
    colorLabel.textAlignment = NSTextAlignmentCenter;
    colorLabel.textColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectZero];
    [headerView addSubview:colorLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kWordListHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWordListCellHeight;
}


@end
