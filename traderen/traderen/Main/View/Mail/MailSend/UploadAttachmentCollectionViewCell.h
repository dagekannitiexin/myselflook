//
//  UploadAttachmentCollectionViewCell.h
//  traderen
//
//  Created by 陈伟杰 on 2017/5/12.
//  Copyright © 2017年 陈伟杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadAttachmentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *AttachmentSmallImageView;
@property (weak, nonatomic) IBOutlet UILabel *attachmentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *attachmentSizeLabel;

@end
