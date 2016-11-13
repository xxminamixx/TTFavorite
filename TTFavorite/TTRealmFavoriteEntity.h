//
//  TTRealmFavoriteEntity.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/10/15.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <Realm/Realm.h>

@interface StringObject : RLMObject

@property NSString *url;

@end
RLM_ARRAY_TYPE(StringObject)

@interface TTRealmFavoriteEntity : RLMObject

@property NSString *name; // ユーザ名
@property NSString *text; // ツイート本文
@property NSString *icon; // アイコン画像url
@property NSString *label; //　フォルダ分け用のlabel
// @property RLMArray<StringObject> *imageList;

@end
