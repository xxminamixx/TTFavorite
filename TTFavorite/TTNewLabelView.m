//
//  TTNewLabelView.m
//  TTFavorite
//
//  Created by 南　京兵 on 2016/10/12.
//  Copyright © 2016年 南　京兵. All rights reserved.
//

#import "TTNewLabelView.h"

@interface TTNewLabelView()

@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)dismissButton:(id)sender;
- (IBAction)commitButton:(id)sender;


@end

@implementation TTNewLabelView

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

- (IBAction)dismissButton:(id)sender
{
    [self.delegate dismissWindow];
}

- (IBAction)commitButton:(id)sender
{
    [self.delegate createLabel:self.textField.text];
}
@end
