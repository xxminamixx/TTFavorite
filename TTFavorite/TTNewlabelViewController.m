//
//  TTNewlabelViewController.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/13.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTNewlabelViewController.h"
#import "TTNewLabelView.h"
#import "TTFavoriteManager.h"

@interface TTNewlabelViewController () <TTNewLabelViewDelegate>

@property (weak, nonatomic) IBOutlet TTNewLabelView *addNewLabelView;

@end

@implementation TTNewlabelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    TTNewLabelView *view = [self.addNewLabelView viewWithTag:1];
    view.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dismissWindow
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createLabel:(NSString *)label
{
    NSLog(@"ラベル作る");
    self.entity.label = label; // ラベルをEntityにセット
    
    [[TTFavoriteManager singleton].favoriteList addObject:self.entity];
    [[TTFavoriteManager singleton] saveLabel:label];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
