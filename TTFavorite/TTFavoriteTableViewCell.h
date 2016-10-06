//
//  TTFavoriteTableViewCell.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFavoriteEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TTFavoriteTableViewCell : UITableViewCell

// セルに行数制限なしのUILabelをセットし、引数の文字列をこのCellのidとするイニシャライザ
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)str;

// Entityを受け取り自身のlabelに名前とテキストをセットする
- (void)setMyProperty:(TTFavoriteEntity *)entity;

// 自身の高さを返す
-(CGFloat) height;

// urlの画像を自身のUIImageViewに表示する
- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;

// 画像を再読み込みする
- (void)imageRefresh:(NSURL *)url;

@end
