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

@interface TTAddLabelViewController ()<TTAddLabelViewDelegate>

@property (weak, nonatomic) IBOutlet TTAddLabelView *addLabelView;

@property NSMutableArray *labelList;

@end

@implementation TTAddLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TTAddLabelView *view = [self.addLabelView viewWithTag:1];
    view.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.labelList = [ud objectForKey:@"LabelList"];
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

@end
