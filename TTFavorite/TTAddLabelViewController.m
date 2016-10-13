//
//  TTAddLabelViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/12.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTAddLabelViewController.h"
#import "TTNewlabelViewController.h"
#import "TTAddLabelView.h"
#import "TTNewLabelView.h"
#import "TTLabelListTableViewCell.h"

@interface TTAddLabelViewController ()<UITableViewDelegate,UITableViewDataSource,TTAddLabelViewDelegate>

@property (weak, nonatomic) IBOutlet TTAddLabelView *addLabelView;
@property (weak, nonatomic) IBOutlet UITableView *labelListTableView;
- (IBAction)commitButton:(id)sender;
- (IBAction)newLabelButton:(id)sender;
- (IBAction)deleteButton:(id)sender;

@property NSMutableArray *labelList;

@end

@implementation TTAddLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelList = [[NSMutableArray alloc] init];
    TTAddLabelView *view = [self.addLabelView viewWithTag:1];
    view.delegate = self;
    
    self.labelListTableView.delegate = self;
    self.labelListTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"TTLabelListTableViewCell" bundle:nil];
    [self.labelListTableView registerNib:nib forCellReuseIdentifier:@"Cell"];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.labelList = [ud objectForKey:@"LabelList"];
    [self.labelListTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLabelViewClose
{
    NSLog(@"閉じる");
    // subView全て削除
//    for (UIView *view in [self.view subviews]) {
//        [view removeFromSuperview];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)useAlreadyLabel
{
    NSLog(@"既存ラベルのデリゲート");
}

- (void)createNewLabel
{
    NSLog(@"新しいラベルのデリゲート");
    TTNewlabelViewController *viewContorller =  [self.storyboard instantiateViewControllerWithIdentifier:@"TTNewlabelViewController"];
    viewContorller.entity = self.entity;
    [self presentViewController:viewContorller animated:YES completion:nil];
}

- (IBAction)commitButton:(id)sender {
}

- (IBAction)newLabelButton:(id)sender
{
    NSLog(@"新しいラベルのデリゲート");
    TTNewlabelViewController *viewContorller =  [self.storyboard instantiateViewControllerWithIdentifier:@"TTNewlabelViewController"];
    viewContorller.entity = self.entity;
    [self presentViewController:viewContorller animated:YES completion:nil];

}

- (IBAction)deleteButton:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"LabelList"];
    [self.labelListTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
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

@end
