//
//  TTAddLabelViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/12.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTAddLabelViewController.h"
#import "TTAddLabelView.h"
#import "TTNewLabelView.h"

@interface TTAddLabelViewController ()<TTAddLabelViewDelegate>

@property (weak, nonatomic) IBOutlet TTAddLabelView *addLabelView;
@property (weak, nonatomic) IBOutlet TTNewLabelView *addNewLabelView;

@end

@implementation TTAddLabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addLabelView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLabelViewClose
{
    NSLog(@"閉じる");
    // subView全て削除
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
}

@end
