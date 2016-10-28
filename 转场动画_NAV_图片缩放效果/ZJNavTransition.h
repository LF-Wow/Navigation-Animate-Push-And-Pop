//
//  ZJNavTransition.h
//  转场动画Demo
//
//  Created by 周君 on 16/9/29.
//  Copyright © 2016年 周君. All rights reserved.
//
/*
 * 使用方法：1、大图页面需要导入ZJNavTransition头文件
 *         2、大图页面需要遵守UINavigationControllerDelegate协议
 *         3、大图页面需要实现方法(直接复制)：
 - (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
 animationControllerForOperation:(UINavigationControllerOperation)operation
 fromViewController:(UIViewController *)fromVC
 toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
 {
 //如果是push就传点击小图时的那张图，如果是pop就传返回时的那张图
 NSInteger index  = operation == UINavigationControllerOperationPush ? self.currendIndexPath.item : _indexPath.item;
 
 return [ZJNavTransition transitionWithType:operation == UINavigationControllerOperationPush ? ZJNavTransitionPush : ZJNavTransitionPop WithImage:[UIImage imageNamed:[NSString stringWithFormat: @"_%lu.jpg",index]]];
            4、让大图成为小图的navigationController的代理
            5、如果有导航栏要在.m文件中吧导航栏的高度写上，如果没有就不写
 }

 
 *
 */

#import <UIKit/UIKit.h>
//用于判断是哪种方式
typedef enum : NSUInteger {
    ZJNavTransitionPush,
    ZJNavTransitionPop,
} ZJNavTransitionType;

@interface ZJNavTransition : NSObject<UIViewControllerAnimatedTransitioning>
//在UINavigationControllerDelegate的协议方法中实现，详见使用法第三条
+ (instancetype)transitionWithType:(ZJNavTransitionType)type WithImage:(UIImage *)image;

@end
