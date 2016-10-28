//
//  ZJBigImageCollectionViewCell.m
//  转场动画_NAV_图片缩放效果
//
//  Created by 周君 on 16/10/4.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJBigImageCollectionViewCell.h"

@interface ZJBigImageCollectionViewCell()

/** 大图片**/
@property (nonatomic, strong) UIImageView *bigImageView;

@end

@implementation ZJBigImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _bigImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0, self.frame.size.width, self.frame.size.height}];
        _bigImageView.clipsToBounds = YES;
        _bigImageView.userInteractionEnabled = YES;
        _bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:_bigImageView];
    }
    
    return self;
}

#pragma mark - 更改约束
- (void)setImage:(UIImage *)image
{
    _bigImageView.image = image;
    
    //得到缩放比例
    float sclX = self.frame.size.width / image.size.width;
    float sclY = self.frame.size.height / image.size.height;
    
    CGFloat imageHeight = image.size.height * sclX;
    CGFloat imageWidth = self.frame.size.width;
    
    if (sclX > sclY)
    {
        imageWidth = image.size.width * sclY;
        imageHeight = self.frame.size.height;
    }

    //这里只能用frame不能用约束，否则当缩放时约束会重新调整位置，没有居中
    _bigImageView.frame = (CGRect){self.frame.size.width / 2 - imageWidth / 2, self.frame.size.height / 2 - imageHeight / 2, imageWidth, imageHeight};

}

@end
