//
//  TTFavoriteTableViewCell.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTFavoriteEntity.h"

@interface TTFavoriteTableViewCell : UITableViewCell

- (void)setMyProperty:(TTFavoriteEntity *)entity;
-(CGFloat) height;

@end
