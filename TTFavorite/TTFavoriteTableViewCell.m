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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1TopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image4Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2TopMargin;

- (IBAction)favoriteButton:(id)sender;
- (IBAction)labelButton:(id)sender;

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

// 自身のプロパティにエンンティティをセット
- (void)setMyProperty:(TTFavoriteEntity *)entity
{
    self.name.text = entity.name;
    self.text.text = entity.text;
    [self imageRefresh:entity.imageList];
}

//#pragma -mark - HeightCalc
//-(CGFloat) height
//{
//    CGFloat margin10 = 10;
//    CGFloat margin5 = 5;
//    CGFloat iconHeight = 80;
//    CGFloat nameLabelHeight = 15; // ユーザ名のラベルの高さ
//    CGFloat imageHeight = 110; // 画像の高さ
//    CGFloat buttonHeight = 15; // お気に入りボタンとラベルボタンの高さ
// 
//    CGFloat bodyLabelW = self.text.bounds.size.width;
//    CGSize bodySize = [self.text.attributedText boundingRectWithSize:CGSizeMake(bodyLabelW, MAXFLOAT)
//                                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                                                                  context:nil].size;
//    
//    if (bodySize.height <= iconHeight){
//        // ラベルの高さがiconの高さを超えない場合
//        return 240;
//    } else {
//        // ラベルの高さがiconのサイズ
//        return nameLabelHeight + (margin10 * 2) +bodySize.height + (margin10) + (imageHeight * 2) + (margin5 * 2) + buttonHeight + (margin5 * 2);
//    }
//    
//}

#pragma -mark - SetImage
/**
 ツイート画像表示処理
 
 - parameter urlList: 画像url(NSString)の配列
 - parameter complatedBlock: 画像表示処理が終わったあとのコールバックBlocks
 */

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
    // 画像レイアウト処理
    [self imageLayoutWithNumberOfImages:urlList.count];
    
    // urlListにurlが格納されていた場合画像表示処理(nilではない)
    if (urlList) {
        [self sd_setImageWithURL:urlList
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           [self setNeedsLayout];
                           [self layoutIfNeeded];
                       }];
    }
}

#pragma -mark - SetIcon
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


#pragma -mark - ButtonAuction
- (IBAction)favoriteButton:(id)sender {
}

- (IBAction)labelButton:(id)sender
{
    [self.delagate showAddLabelView];
}

#pragma -mark - ImageLayout
// 画像の数によってレイアウトを変化させる
- (void)imageLayoutWithNumberOfImages:(NSInteger)numberOfImages
{
    switch (numberOfImages) {
        case 0:
            // 画像なしのときの処理
            // 各UIImageの高さ制約を0にする
            self.image1Height.constant = 0;
            self.image2Height.constant = 0;
            self.image3Height.constant = 0;
            self.image4Height.constant = 0;
            break;
        case 1:
            // 1個のときの処理
            self.image1Height.constant = 110;
            self.image2Height.constant = 110;
            self.image2.hidden = YES;
            self.image3Height.constant = 0;
            self.image4Height.constant = 0;
            // image1の下のマージンを0にする必要ある？
            break;
        case 2:
            // 2個のときの処理
            self.image1Height.constant = 110;
            self.image2Height.constant = 110;
            self.image2.hidden = NO;
            self.image3Height.constant = 0;
            self.image4Height.constant = 0;
            break;
        case 3:
            // 3個のときの処理
            self.image1Height.constant = 110;
            self.image2Height.constant = 110;
            self.image2.hidden = NO;
            self.image3Height.constant = 110;
            self.image4Height.constant = 0;
            break;
        case 4:
            // 4個のときの処理
            self.image1Height.constant = 110;
            self.image2Height.constant = 110;
            self.image2.hidden = NO;
            self.image3Height.constant = 110;
            self.image4Height.constant = 110;
            break;
        default:
            break;
    }
}

@end
