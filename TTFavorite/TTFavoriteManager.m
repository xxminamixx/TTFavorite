//
//  TTFavoriteManager.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/13.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTFavoriteManager.h"
#import "TTRealmFavoriteEntity.h"
#import <Realm/Realm.h>

@interface TTFavoriteManager()

@property RLMRealm *realm;

@end

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

// realm永続化メソッド
- (void)saveEntity
{
     TTRealmFavoriteEntity *entity = [[TTRealmFavoriteEntity alloc] init];
    
    [self.realm beginWriteTransaction];
    // シングルトンで管理しているEntityを配列から取り出し保存
    for (entity in self.favoriteList) {
        [self.realm addObject:entity];
    }
    [self.realm commitWriteTransaction];
}

// plistかRealmで永続化されたEntity配列を自身のプロパティにセット
- (void)loadEntity
{
    self.realm = [RLMRealm defaultRealm];
    
    RLMResults *defresults = [TTRealmFavoriteEntity allObjects];
    self.favoriteList = [[NSMutableArray alloc] init];
        
    if (defresults.count > 0) {
        for (TTRealmFavoriteEntity *entity in defresults) {
            [self.favoriteList addObject:entity];
        }
    }
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
