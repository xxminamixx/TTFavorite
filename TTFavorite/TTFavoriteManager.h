//
//  TTFavoriteManager.h
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/13.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFavoriteManager : NSObject

@property NSMutableArray *favoriteList; //ラベルのついたお気に入りを管理

+ (TTFavoriteManager *)singleton;
- (void)saveLabel:(NSString *)label;
- (void)saveEntity;
- (void)loadEntity;

@end
