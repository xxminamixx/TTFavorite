//
//  TTAddLabelView.h
//  TTFavorite
//
//  Created by kyohei.minami on 2016/10/09.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTAddLabelViewDelegate <NSObject>

- (void)addLabelViewClose;
- (void)useAlreadyLabel;
- (void)createNewLabel;

@end

@interface TTAddLabelView : UIView

@property (weak, nonatomic) id<TTAddLabelViewDelegate>delegate;

@end
