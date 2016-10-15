//
//  TTFavoriteTableViewCell.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTRealmFavoriteEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol TTFavoriteTableViewCellDelegate <NSObject>

- (void)showAddLabelView:(TTRealmFavoriteEntity *)entity;

@end

@interface TTFavoriteTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TTFavoriteTableViewCellDelegate> delagate;

// Entityを受け取り自身のlabelに名前とテキストをセットする
- (void)setMyProperty:(TTRealmFavoriteEntity *)entity;

// urlの画像を自身のUIImageViewに表示する
- (void)sd_setImageWithURL:(NSMutableArray *)urlList completed:(SDWebImageCompletionBlock)completedBlock;

// 画像を再読み込みする
- (void)imageRefresh:(NSMutableArray *)urlList;

- (void)sd_setIconWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock;
- (void)iconRefresh:(NSURL *)url;

@end
