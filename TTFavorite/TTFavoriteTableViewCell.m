//
//  TTFavoriteTableViewCell.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTFavoriteTableViewCell.h"

@interface TTFavoriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation TTFavoriteTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setMyProperty:(TTFavoriteEntity *)entity
{
    self.name.text = entity.name;
    self.text.text = entity.text;
}

@end
