//
//  TagLabelView.m
//  traderen
//
//  Created by 陈伟杰 on 2017/4/25.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import "TagLabelView.h"
#import "TagLabel.h"

@implementation TagLabelView


- (void)bindTags:(NSArray<NSString *> *)tags {
    if (self.subviews.count > 0) {
        for (TagLabel *label in self.subviews) {
            [label removeFromSuperview];
        }
    }
    
    CGFloat frameWidth = self.frame.size.width;
    
    CGFloat tagsTotalWidth = 0.0f;
    CGFloat tagsTotalHeight = 0.0f;
    
    CGFloat tagHeight = 0.0f;
    for (NSString *tag in tags) {
        TagLabel *tagLabel = [[TagLabel alloc] initWithFrame:CGRectMake(tagsTotalWidth, tagsTotalHeight, 0, 0)];
        tagLabel.text = tag;
        tagsTotalWidth += tagLabel.frame.size.width + 2;
        tagHeight = tagLabel.frame.size.height;
        
        if(tagsTotalWidth >= frameWidth)
        {
            tagsTotalHeight += tagLabel.frame.size.height + 2;
            tagsTotalWidth = 0.0f;
            tagLabel.frame = CGRectMake(tagsTotalWidth, tagsTotalHeight, tagLabel.frame.size.width, tagLabel.frame.size.height);
            tagsTotalWidth += tagLabel.frame.size.width + 2;
        }
        [self addSubview:tagLabel];
    }
    tagsTotalHeight += tagHeight;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, tagsTotalHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
