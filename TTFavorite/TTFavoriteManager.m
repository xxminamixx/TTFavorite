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

- (id)init{
    
    if([super init] != nil) {
        self.favoriteList = [[NSMutableArray alloc] init];
    }
    return self;
}

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
    BOOL isAlreadyLabel = NO; //同じラベルがすでに追加されているか判定
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *labelList = [[ud objectForKey:@"LabelList"] mutableCopy]; // 永続化されいてるラベル配列を取得;
    if (!labelList) {
        labelList = [[NSMutableArray alloc] init];
    }
    //　すでに同じラベルがないことを判定
    for (NSString *alreadyLabel in labelList) {
        if([alreadyLabel isEqualToString:label]) {
            isAlreadyLabel = YES;
        }
    }
    
    //同じラベルがなかったら
    if (!isAlreadyLabel) {
        [labelList addObject:label]; // ラベルを追加
        [ud setObject:labelList forKey:@"LabelList"]; //　永続化
    }
}

@end
