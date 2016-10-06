//
//  TTFavoriteEntity.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFavoriteEntity : NSObject

@property NSString *name; // ユーザ名
@property NSString *text; // ツイート本文
@property NSString *image; // 画像があった場合のurl
@property NSString *icon; // アイコン画像url
@property NSString *label; //　フォルダ分け用のlabel

@end
