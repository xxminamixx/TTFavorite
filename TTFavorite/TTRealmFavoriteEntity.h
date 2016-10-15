//
//  TTRealmFavoriteEntity.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/10/15.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <Realm/Realm.h>

@interface TTRealmFavoriteEntity : RLMObject

@property NSString *name; // ユーザ名
@property NSString *text; // ツイート本文
@property NSMutableArray *imageList; // 画像があった場合のurl
@property NSString *icon; // アイコン画像url
@property NSString *label; //　フォルダ分け用のlabel

@end
