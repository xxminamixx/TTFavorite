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
#import "TTFavoriteManager.h"

@interface TTAddLabelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *labelListTableView;
- (IBAction)newLabelButton:(id)sender;
- (IBAction)deleteButton:(id)sender;

@property NSMutableArray *labelList;

@end

@implementation TTAddLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"ラベル選択";
    
    self.labelList = [[NSMutableArray alloc] init];

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)addLabelViewClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)useAlreadyLabel
{
    
}

- (void)createNewLabel
{
    TTNewlabelViewController *viewContorller =  [self.storyboard instantiateViewControllerWithIdentifier:@"TTNewlabelViewController"];
    viewContorller.entity = self.entity;
    [self presentViewController:viewContorller animated:YES completion:nil];
}

- (IBAction)newLabelButton:(id)sender
{
    TTNewlabelViewController *viewContorller =  [self.storyboard instantiateViewControllerWithIdentifier:@"TTNewlabelViewController"];
    viewContorller.entity = self.entity;
    [self presentViewController:viewContorller animated:YES completion:nil];

}

- (IBAction)deleteButton:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"LabelList"];
    self.labelList = nil;
    [self.labelListTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.labelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTLabelListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.label.text = self.labelList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.entity.label = self.labelList[indexPath.row];
    [[TTFavoriteManager singleton].favoriteList addObject:self.entity];
    [[TTFavoriteManager singleton] saveLabel:self.labelList[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
