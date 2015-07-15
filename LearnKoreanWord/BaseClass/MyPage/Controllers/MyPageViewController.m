//
//  MyPageViewController.m
//  LearnKoreanWord
//
//  Created by diguojin on 15/6/28.
//  Copyright (c) 2015年 diguojin. All rights reserved.
//

#import "MyPageViewController.h"
#import "DB.h"
#import "MyPageTableViewCell.h"
#import "CRGradientLabel.h"
#import "UILabel+FlickerNumber.h"

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"统计";
    _mydb = [DB sharedDBWithName:kTargetDBFile];
    _totalMemWordsCount = [_mydb getMyWordsMemWordsCount];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:kMyPageTavleViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kMyPageTavleViewCell];
    [self.view addSubview:_tableView];
    
    _pullDownRefreshControl = [[UIRefreshControl alloc]init];
    //_pullDownRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新数据"];
    [_pullDownRefreshControl addTarget:self action:@selector(doRefresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_pullDownRefreshControl];
}

- (void)doRefresh
{
    _totalMemWordsCount = [_mydb getMyWordsMemWordsCount];
    [_tableView reloadData];
    [_pullDownRefreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MyPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyPageTavleViewCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyPageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyPageTavleViewCell];
    }
    
    switch (indexPath.row) {
        case 0:{
            CRGradientLabel *colorLabel = [[CRGradientLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
            colorLabel.gradientColors = @[[UIColor redColor],[UIColor orangeColor]];
            cell.backgroundView = colorLabel;
            cell.iconImgView.image = [UIImage imageNamed:@"calendar_white"];
            cell.titleLabel.text = @"今日新增词汇量";
            cell.titleLabel.textColor = [UIColor whiteColor];
            //cell.NumberLabel.text = [NSString stringWithFormat:@"%ld", (long)_totalMemWordsCount];
            cell.NumberLabel.textColor = [UIColor whiteColor];
            NSLog(@"%ld",(long)[_mydb getMyTodayWordsMemWordsCount]);
            [cell.NumberLabel dd_setNumber:[NSNumber numberWithLong:(long)[_mydb getMyTodayWordsMemWordsCount]] format:nil];
            break;
        }
        case 1:{
            cell.iconImgView.image = [UIImage imageNamed:@"total"];
            cell.titleLabel.text = @"词汇量";
            cell.titleLabel.textColor = [UIColor grayColor];
            [cell.NumberLabel dd_setNumber:[NSNumber numberWithLong:(long)_totalMemWordsCount] format:nil];

            cell.NumberLabel.textColor = [UIColor orangeColor];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

@end
