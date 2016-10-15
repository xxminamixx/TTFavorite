//
//  HomeViewController.h
//  TTFavorite
//
//  Created by 南　京兵 on 2016/08/23.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completedBlock)(void);

@interface TTHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;
- (void)fetchFavoriteForUser:(NSString *)userName completed:(completedBlock)block;

@end
