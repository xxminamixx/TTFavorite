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
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;

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

- (void)sd_setImageWithURL:(NSMutableArray *)urlList completed:(SDWebImageCompletionBlock)completedBlock
{
    for (int i = 0; i < urlList.count; i++) {
        
        NSURL *url = [NSURL URLWithString:urlList[i]];
        
        switch (i) {
            case 0:
                [self.image sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
                break;
            case 1:
                 [self.image2 sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
                break;
            case 2:
                 [self.image3 sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
                break;
            case 3:
                 [self.image4 sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
                break;
            default:
                break;
        }
    }
}

- (void)imageRefresh:(NSMutableArray *)urlList
{
    // 画像が4枚以下の場合使われないUIImageViewのサイズを0にする処理がここに必要
    // 配列の要素数から必要のないUIImageがわかる
    
    [self sd_setImageWithURL:urlList
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
