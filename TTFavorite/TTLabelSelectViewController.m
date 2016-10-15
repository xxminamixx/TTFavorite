//
//  TTLabelSelectViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/14.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTLabelSelectViewController.h"
#import "TTLabelListTableViewCell.h"
#import "TTSameLabelViewController.h"

@interface TTLabelSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *labelListTableView;

@property NSMutableArray *labelList;

@end

@implementation TTLabelSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.labelListTableView.delegate = self;
    self.labelListTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"TTLabelListTableViewCell" bundle:nil];
    [self.labelListTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    //ラベルリストの読み込み
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.labelList = [[ud objectForKey:@"LabelList"] mutableCopy];
    [self.labelListTableView reloadData];
}

#pragma -mark - UITableViewDataSource
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.labelList.count;
}

- (UITableViewCell *)tableView:
(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTLabelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.label.text = self.labelList[indexPath.row];
    return cell;
}

#pragma -mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTSameLabelViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TTSameLabelViewController"];
    viewController.label = self.labelList[indexPath.row]; // 選択したセルのラベルを次画面へ渡す
    [self.navigationController pushViewController:viewController animated:YES];
    

}

@end
