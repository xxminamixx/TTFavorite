//
//  TTAddLabelViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/12.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTAddLabelViewController.h"
#import "TTAddLabelView.h"

@interface TTAddLabelViewController ()

@end

@implementation TTAddLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TTAddLabelView *view = [[TTAddLabelView alloc] initWithFrame:CGRectMake(0, 0, 375, 230)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
