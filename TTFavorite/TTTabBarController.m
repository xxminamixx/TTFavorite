//
//  TTTabBarController.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/10/15.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTTabBarController.h"

@interface TTTabBarController ()

@end

@implementation TTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *homeItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *folderItem = [self.tabBar.items objectAtIndex:1];
    
    homeItem.title = @"home";
    folderItem.title = @"folder";
    
    homeItem.image = [[UIImage imageNamed:@"home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    homeItem.selectedImage = [[UIImage imageNamed:kHomeImageFilledStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    folderItem.image = [[UIImage imageNamed:@"folder.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    favoItem.selectedImage = [[UIImage imageNamed:kFavoImageFilledStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
