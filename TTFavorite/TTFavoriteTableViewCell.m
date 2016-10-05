//
//  TTFavoriteTableViewCell.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTFavoriteTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"

@interface TTFavoriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end

@implementation TTFavoriteTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.text = [[UILabel alloc] init];
        // 行数制限なし
        self.text.numberOfLines = 0;
        [self addSubview:self.text];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

// 自身のプロパティにエンンティティをセット
- (void)setMyProperty:(TTFavoriteEntity *)entity
{
    self.name.text = entity.name;
    self.text.text = entity.text;
}

-(CGFloat) height
{
    CGFloat pad = 10;
    CGFloat bodyLabelW = self.text.bounds.size.width;
    CGSize bodySize = [self.text.attributedText boundingRectWithSize:CGSizeMake(bodyLabelW, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                  context:nil].size;
    return bodySize.height + pad * 2 + 20;
}

//- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
//{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [self.shopLogo sd_setImageWithURL:url placeholderImage:loadImage options:0 progress:nil completed:completedBlock];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//}
//
//- (void)imageRefresh:(NSURL *)url
//{
//    [self sd_setImageWithURL:url
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                       [self setNeedsLayout];
//                       [self layoutIfNeeded];
//                   }];
//}

@end
