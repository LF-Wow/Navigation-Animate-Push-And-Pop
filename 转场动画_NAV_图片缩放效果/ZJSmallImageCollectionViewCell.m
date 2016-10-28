//
//  ZJSmallImageCollectionViewCell.m
//  转场动画_NAV_图片缩放效果
//
//  Created by 周君 on 16/10/4.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJSmallImageCollectionViewCell.h"

@interface ZJSmallImageCollectionViewCell()

/** 小图片**/
@property (nonatomic, strong) UIImageView *samllImage;


@end

@implementation ZJSmallImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _samllImage = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
        
        [self addSubview:_samllImage];
    }
    
    return self;
}

- (void)setValueWithImage:(UIImage *)image
{
    self.samllImage.image = image;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
