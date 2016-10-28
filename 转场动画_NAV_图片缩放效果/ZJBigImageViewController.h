//
//  ZJBigImageViewController.h
//  转场动画_NAV_图片缩放效果
//
//  Created by 周君 on 16/10/4.
//  Copyright © 2016年 周君. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJBigImageViewController : UIViewController<UINavigationControllerDelegate>

/** 当前选择的cell**/
@property (nonatomic, strong) NSIndexPath *currendIndexPath;

@end
