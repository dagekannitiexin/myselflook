//
//  RecipientLabelView.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/25.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "RecipientLabelView.h"
#import "UIView+Extension.h"

@implementation RecipientLabelView

- (void)bindRecipients:(NSArray<NSString *> *)Strings {
    if (self.subviews.count > 0) {
        for (UILabel *label in self.subviews) {
            [label removeFromSuperview];
        }
    }
    
    CGFloat labelHeight = 0.0f;
    for (NSString *str in Strings) {
        UILabel *recipientLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            recipientLabel.font = [UIFont systemFontOfSize:12.0f];
            recipientLabel.textColor = [UIColor lightGrayColor];
        recipientLabel.textAlignment = NSTextAlignmentLeft;
        recipientLabel.text = str;
        CGSize size = [recipientLabel.text sizeWithAttributes:@{NSFontAttributeName: recipientLabel.font}];
        recipientLabel.frame = CGRectMake(recipientLabel.x, recipientLabel.y + labelHeight, size.width, size.height);
        labelHeight += recipientLabel.height;
        [self addSubview:recipientLabel];
        
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
