//
//  HomeViewController.h
//  TTFavorite
//
//  Created by 南　京兵 on 2016/08/23.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTHomeViewController : UIViewController

- (void)fetchTimelineForUser:(NSString *)username;
- (void)fetchFavoriteForUser:(NSString *)userName;

@end
