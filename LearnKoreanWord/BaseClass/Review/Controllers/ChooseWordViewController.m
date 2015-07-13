//
//  ChooseWordViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/7/3.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "ChooseWordViewController.h"
#import "ChooseWordView.h"
#import "UIView+Shadow.h"
#import "CRGradientLabel.h"
#import "WordListViewCell.h"

@interface ChooseWordViewController ()

@end

@implementation ChooseWordViewController
- (WordList *)wordList
{
    if (!_wordList) _wordList = [[WordList alloc]init];;
    return _wordList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _chooseWordView = [[ChooseWordView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_wordList random4Kr];

    self.view.userInteractionEnabled = YES;
    
    _chooseWordView.userInteractionEnabled = YES;
    
    [self.view addSubview:_chooseWordView];
    self.title = @"开始回忆";
    
    
#pragma mark -buttons-
    CGFloat baseY = SCREEN_HEIGHT / 2 ;
    CGFloat baseWidth = SCREEN_WIDTH / 2;
    CGFloat baseHeight = ((SCREEN_HEIGHT / 2 ) - 49 ) / 2;
    
    
    _btn1 = [[BigButtonView alloc]initWithFrame:CGRectMake(0, baseY, 0, baseHeight)];
    _btn1.backgroundColor = COLOR_1;
    _btn1.delegate = self;
    [self.view addSubview:_btn1];

    
    _btn2 = [[BigButtonView alloc]initWithFrame:CGRectMake(baseWidth, baseY, 0, baseHeight)];
    _btn2.backgroundColor  = COLOR_2;
    _btn2.delegate = self;
    [self.view  addSubview:_btn2];
    
    _btn3 = [[BigButtonView alloc]initWithFrame:CGRectMake(0, baseY + _btn1.frame.size.height, 0, baseHeight)];
    _btn3.backgroundColor  = COLOR_3;
    _btn3.delegate = self;
    [self.view  addSubview:_btn3];
    
    _btn4 = [[BigButtonView alloc]initWithFrame:CGRectMake(baseWidth, baseY + _btn3.frame.size.height, 0, baseHeight)];
    _btn4.backgroundColor  = COLOR_4;
    _btn4.delegate = self;
    [self.view  addSubview:_btn4];
    
    
    [self updateUI];
    // Do any additional setup after loading the view.
}


#warning 存在大量重复代码有待优化

//更新视图数据
- (void)updateUI
{
    _chooseWordView.krWordLabel.text = _wordList.getWord.kr;
    NSMutableArray *randomIndexArray = [_wordList random4Kr];
    
    self.btn1.text = [[_wordList getWordAtIndex:[randomIndexArray[0] integerValue]] zh];
    self.btn2.text = [[_wordList getWordAtIndex:[randomIndexArray[1] integerValue]] zh];
    self.btn3.text = [[_wordList getWordAtIndex:[randomIndexArray[2] integerValue]] zh];
    self.btn4.text = [[_wordList getWordAtIndex:[randomIndexArray[3] integerValue]] zh];
    
    self.btn1.hidden = NO;
    self.btn2.hidden = NO;
    self.btn3.hidden = NO;
    self.btn4.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//判断答案是否正确
- (void)checkAnswer:(NSString *)answer
{
    NSLog(@"我提交的答案是%@",answer);
    if ([answer isEqualToString:[[_wordList getWord] zh]]) {
        NSLog(@"回答正确%@",answer);

        NSInteger result = [_wordList nextWord];
        if (result == 2) {
            NSLog(@"单元结束");
            [self finishChapter];
        }else{
            [self showAnswerHUDIsCorrect:YES];
        }
        [self updateUI];
        
    }else{
        NSLog(@"回答错误%@",answer);
        [self showAnswerHUDIsCorrect:NO];
        [_wordList addWrongWord];
        [self hideWrongAnswer];
    }
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
        NSLog(@"当前单词记忆率: %f",memParam);
        
        //根据之前的记忆率来修正即将更新的单词记忆量
        NSInteger wordsCountWillUpdate = wordsCountRemembered - [_wordList count] * memParam;
        
        //更新记忆的单词量
        [mydb updateMyWordsWithMemCount:wordsCountWillUpdate];
        
        //更新单词记忆率
        newMemParam = wordsCountRemembered / (double)[_wordList count];

        [mydb setMemoryParamWidthChapter:chapterId MemParam: newMemParam];
        NSLog(@"更新后的单词记忆率: %f", newMemParam);

    }
    
    [self showResult];
    if (newMemParam == 1.000000) {
        [self showAnswerFinishHUDAllIsCorrect:YES];
    }else{
        [self showAnswerFinishHUDAllIsCorrect:NO];
    }
}

- (void)hideWrongAnswer
{
    if (![self.btn1.text isEqualToString:[[_wordList getWord] zh]]) {
        self.btn1.hidden = YES;
    }
    if (![self.btn2.text isEqualToString:[[_wordList getWord] zh]]) {
        self.btn2.hidden = YES;
    }
    if (![self.btn3.text isEqualToString:[[_wordList getWord] zh]]) {
        self.btn3.hidden = YES;
    }
    if (![self.btn4.text isEqualToString:[[_wordList getWord] zh]]) {
        self.btn4.hidden = YES;
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


#pragma mark -uitableviewDelegate-

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
