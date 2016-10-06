//
//  TTFavoriteTableViewCell.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/09/10.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTFavoriteTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"

@interface TTFavoriteTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (IBAction)favoriteButton:(id)sender;
- (IBAction)labelButton:(id)sender;

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
    CGFloat margin10 = 10;
    CGFloat margin5 = 5;
    CGFloat iconHeight = 80;
    CGFloat nameLabelHeight = 15; // ユーザ名のラベルの高さ
    CGFloat imageHeight = 100; // 画像の高さ
    CGFloat buttonHeight = 30; // お気に入りボタンとラベルボタンの高さ
    
    CGFloat bodyLabelW = self.text.bounds.size.width;
    CGSize bodySize = [self.text.attributedText boundingRectWithSize:CGSizeMake(bodyLabelW, MAXFLOAT)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                  context:nil].size;
    
    if (bodySize.height <= iconHeight){
        // ラベルの高さがiconの高さを超えない場合
        return 240;
    } else {
        // ラベルの高さがiconのサイズ
        return nameLabelHeight + (margin10 * 2) +bodySize.height + (margin10) + imageHeight + (margin5 * 2) + buttonHeight;
    }
    
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
{
    [self.image sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)imageRefresh:(NSURL *)url
{
    [self sd_setImageWithURL:url
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       [self setNeedsLayout];
                       [self layoutIfNeeded];
                   }];
}

- (void)sd_setIconWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock
{
    [self.icon sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)iconRefresh:(NSURL *)url
{
    [self sd_setIconWithURL:url
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [self setNeedsLayout];
                        [self layoutIfNeeded];
                   }];
}

- (IBAction)favoriteButton:(id)sender {
}

- (IBAction)labelButton:(id)sender {
}
@end
