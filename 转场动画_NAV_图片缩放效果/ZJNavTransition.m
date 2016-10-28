//
//  ZJNavTransition.m
//  转场动画Demo
//
//  Created by 周君 on 16/9/29.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJNavTransition.h"

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZJNavTransition()

/** 判断转场同**/
@property (nonatomic, assign) ZJNavTransitionType type;
/** 缩放图片**/
@property (nonatomic, strong) UIImage *image;

@end

/** 小图的原始位置**/
static NSIndexPath *initIndexPath;
/** 小图的返回位置**/
static NSIndexPath *returnIndexPath;
/** 小图的原始大小**/
static CGRect initFrame;
/** 小图的collectionview视图**/
static UICollectionView *smallCollectionView;
/** 一行有几个**/
static NSInteger rowItemCount = 4;
/** 导航栏高度如果没有导航栏这就填0**/
static NSInteger NAVHeight = 64;

@implementation ZJNavTransition

+ (instancetype)transitionWithType:(ZJNavTransitionType)type WithImage:(UIImage *)image
{
    return [[self alloc] initTransitionWithType:type WithImage:image];
    
}

- (instancetype)initTransitionWithType:(ZJNavTransitionType)type WithImage:(UIImage *)image
{
    if (self = [super init])
    {
        _type = type;
        _image = image;
    }
    
    return self;
}

//动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

//执行哪一种动画
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case ZJNavTransitionPush:
            [self doPushAnimateTransition:transitionContext];
            break;
        case ZJNavTransitionPop:
            [self doPopAnimateTransition:transitionContext];
            break;
    }
}

- (void)doPushAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    //拿到两个控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //找到CollectionView
    for (UICollectionView *view in fromVC.view.subviews)
    {
        if ([view isKindOfClass:[UICollectionView class]])
        {
            smallCollectionView = view;
        }
    }
    initIndexPath = [smallCollectionView indexPathsForSelectedItems][0];
    UICollectionViewCell *cell = [smallCollectionView cellForItemAtIndexPath:initIndexPath];
    
    //获取过渡用的视图
    UIView *containerView = [transitionContext containerView];
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:imageView];
    
    //设置动画前各个控件的状态
    fromVC.view.hidden = YES;
    toVC.view.alpha = 0;
    for (UIView *view in toVC.view.subviews)
    {
        view.hidden = YES;
    }
    
    //算坐标，
//    CGFloat x = cell.frame.origin.x;
//    CGFloat y = cell.frame.origin.y - _detailsCollectionView.contentOffset.y;
//    CGFloat orgWight = cell.frame.size.width;
//    CGFloat orgHeight = cell.frame.size.height;
//    initFrame =CGRectMake(x, y, orgWight, orgHeight);
    //设置图片开始在cell的位置，转换cell的位置信息给动画图片
    imageView.frame = [cell convertRect:cell.bounds toView:containerView];
    initFrame = imageView.frame;
    //获取要缩放的图片
    imageView.image = _image;
    
    //设置图片进行缩放后的高和宽
    CGFloat height = imageView.image.size.height * (fromVC.view.frame.size.width / imageView.image.size.width);
    CGFloat wight = fromVC.view.frame.size.width;
   
    //让图片变大放在屏幕中央
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        imageView.frame = CGRectMake(0, ((fromVC.view.frame.size.height + NAVHeight) / 2) - (height / 2), wight, height);
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        
        for (UIView *view in toVC.view.subviews)
        {
            view.hidden = NO;
        }
        imageView.hidden = YES;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}

- (void)doPopAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
   
    //这里是缩小回去的动画,fromVC是大图浏览界面的控制器，toVC是小图浏览界面的控制器。
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UICollectionView *BigImageCollectionView;
    //找到CollectionView
    for (UIView *view in fromVC.view.subviews)
    {
        if ([view isKindOfClass:[UICollectionView class]])
        {
            BigImageCollectionView = (UICollectionView *)view;
        }
    }
    
    if (!BigImageCollectionView)
    {
        for (UIView *view in fromVC.view.subviews)
        {
            for (UICollectionView *collectionView in view.subviews)
            {
                if ([collectionView isKindOfClass:[UICollectionView class]])
                {
                    BigImageCollectionView = collectionView;
                }
            }
        }
    }
    
    
    //得到大图页面的cell，主要是为了用那张图片，因为动画的图片用的是大图
    UICollectionViewCell *bigImageCell = BigImageCollectionView.visibleCells[0];
    
    //在这里拿到大图界面返回时候的indexPath
    returnIndexPath = [BigImageCollectionView indexPathForCell:bigImageCell];
    
    //这里是之前点击的小图的位置
//    NSIndexPath *initIndexPath = toVC.indexPath;
    
    //这里做一个判断，如果是同一行，那么就不用改变contentSize
    if ((returnIndexPath.item / rowItemCount) !=  (initIndexPath.item / rowItemCount))
    {
        
        //算出原始的cell距离屏幕边缘有几行（用到屏幕边缘的距离对cell的高度取整），如果要返回的cell在下面就用屏幕减去原始cell的最大Y值，否则就用原始的Y值
        NSInteger rowCount = returnIndexPath.item > initIndexPath.item ?  (SCREENHEIGHT - 64 - CGRectGetMaxY(initFrame)) / initFrame.size.height : initFrame.origin.y / initFrame.size.height;
        //得到要返回的cell距离开始的cell距离几个item
        NSInteger abs = returnIndexPath.item - initIndexPath.item;
        //当前的位置距离原始位置几行
        NSInteger distanceCount = labs(abs) / rowItemCount;
        //距离的格子数目小于rowItemCount格（一行就rowItemCount格），那么久让行数加一
        labs(abs) < rowItemCount ? distanceCount++ : distanceCount;
        //当前距离原始的行数大于原始距离屏幕的行数，就需要滚动
        if (distanceCount > rowCount)
        {
            //得到contentSize需要增加或减少的长度
            NSInteger scrollCount = abs > 0 ? distanceCount : -distanceCount;
            //如果
            if(labs(abs) % rowItemCount != 0)
            {
                if (scrollCount > 0)
                {
                    scrollCount += 1;
                }
                else
                {
                    scrollCount -= 1;
                }
                
            }
            smallCollectionView.contentOffset =(CGPoint){0, smallCollectionView.contentOffset.y + (initFrame.size.height + 2) * scrollCount};
        }
    }
    
    //得到要返回的cell，根据indexPath
    UICollectionViewCell *currendCell = [smallCollectionView cellForItemAtIndexPath:returnIndexPath];
    
    
    //这里就是过渡动画的那个视图了
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIImageView *tempView = containerView.subviews.lastObject;
    
    tempView.image = _image;
    
    //设置初始状态
    currendCell.hidden = YES;
    fromVC.view.hidden = YES;
    tempView.hidden = NO;
    toVC.view.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    
    //一个蒙版遮住原来位置的图
    UIView *view;
    if (!currendCell)
    {
        view  = [[UIView alloc] initWithFrame:[self returnFrameWithIndexPath:returnIndexPath AndInitFrame:initFrame]];
        view.backgroundColor = toVC.view.backgroundColor;
        [toVC.view addSubview:view];
    }

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        if (currendCell)
        {
            tempView.frame = [currendCell convertRect:currendCell.bounds toView:containerView];
        }
        else
        {
            tempView.frame = [self returnFrameWithIndexPath:returnIndexPath AndInitFrame:initFrame];
        }
        
        fromVC.view.alpha = 0;
        
    } completion:^(BOOL finished) {
        //如果加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            fromVC.view.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            currendCell.hidden = NO;
            [tempView removeFromSuperview];
            if (!currendCell)
            {
                [view removeFromSuperview];
            }
        }
    }];
    
}

#pragma mark - 计算返回的坐标
- (CGRect)returnFrameWithIndexPath:(NSIndexPath *)indexPath AndInitFrame:(CGRect)initFrame
{
    CGFloat returnWidth = initFrame.size.width;
    CGFloat returnHeight = initFrame.size.height;
    CGFloat returnX = (indexPath.item % rowItemCount) * (initFrame.size.width + 2);
    CGFloat returnY = initFrame.origin.y;
    
    return (CGRect){returnX, returnY, returnWidth, returnHeight};
                                              
}

@end
