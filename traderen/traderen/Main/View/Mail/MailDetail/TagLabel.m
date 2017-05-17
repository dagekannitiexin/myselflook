//
//  TagLabel.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/25.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "TagLabel.h"

#define MAX_SIZE_HEIGHT 10000
#define DEFAULT_BACKGROUDCOLOR [UIColor colorWithRed:47.0/255 green:157.0/255 blue:216.0/255 alpha:1]
#define DEFAULT_TEXTCOLOR [UIColor whiteColor]
#define DEFAULT_FONT [UIFont boldSystemFontOfSize:10]
#define DEFAULT_TEXTALIGNMENT NSTextAlignmentCenter
#define DEFAULT_RADIUS 2.0f

@implementation TagLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = DEFAULT_BACKGROUDCOLOR;
        self.textColor = DEFAULT_TEXTCOLOR;
        self.font = DEFAULT_FONT;
        self.textAlignment = DEFAULT_TEXTALIGNMENT;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = DEFAULT_RADIUS;
        
    }
    return self;
}

//- (void)setRadius:(CGFloat)radius {
//    [super ];
//    self.layer.cornerRadius = radius;
//}

- (void)setText:(NSString *)text {
    [super setText:text];
    
//    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(320, MAX_SIZE_HEIGHT) lineBreakMode:UILineBreakModeWordWrap];
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + 8, size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
