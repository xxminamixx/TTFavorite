//
//  TTAddLabelView.m
//  TTFavorite
//
//  Created by kyohei.minami on 2016/10/09.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTAddLabelView.h"

@interface TTAddLabelView()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)dismissWindow:(id)sender;
- (IBAction)alreadyLabel:(id)sender;
- (IBAction)newLabel:(id)sender;

@end

@implementation TTAddLabelView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (!self.subviews.count) {
            UIView *subview = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
            subview.frame = self.bounds;
            subview.tag = 1;
            [self addSubview:subview];
        }
    }
    return self;
}

- (IBAction)dismissWindow:(id)sender
{
    NSLog(@"閉じます");
    [self.delegate addLabelViewClose];
}

- (IBAction)alreadyLabel:(id)sender
{
    NSLog(@"既存ラベルをつけます");
    [self.delegate useAlreadyLabel];
}

- (IBAction)newLabel:(id)sender
{
    NSLog(@"新しいラベルをつけます");
    [self.delegate createNewLabel];
}
@end
