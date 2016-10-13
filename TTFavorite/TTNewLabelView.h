//
//  TTNewLabelView.h
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/12.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTNewLabelViewDelegate <NSObject>

- (void)dismissWindow; // 閉じるボタンを押した時のデリゲート
- (void)createLabel:(NSString *)label; // 決定ボタンをおしたときのデリゲート

@end

@interface TTNewLabelView : UIView

@property (weak, nonatomic) id<TTNewLabelViewDelegate>delegate;

@end
