//
//  TTFavoriteManager.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/13.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTFavoriteManager.h"

static TTFavoriteManager *sharedInstance = nil;

@implementation TTFavoriteManager

+ (TTFavoriteManager *)singleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TTFavoriteManager alloc] init];
    });
    return sharedInstance;
}

- (void)saveLabel:(NSString *)label
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *labelList = [ud objectForKey:@"LabelList"]; // 永続化されいてるラベル配列を取得;
    [labelList addObject:label]; // ラベルを追加
    [ud setObject:labelList forKey:@"LabelList"]; //　永続化
}

@end