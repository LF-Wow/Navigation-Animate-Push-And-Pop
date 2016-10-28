//
//  ZJBigImageViewController.m
//  转场动画_NAV_图片缩放效果
//
//  Created by 周君 on 16/10/4.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJBigImageViewController.h"
#import "GlobalDefine.h"
#import "Masonry.h"
#import "ZJBigImageCollectionViewCell.h"
#import "ZJNavTransition.h"

@interface ZJBigImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** 当前显示的indexPath**/
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation ZJBigImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = (CGSize){SCREENWIDTH, SCREENHEIGHT - 64};
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    
    UICollectionView *imageBrowsCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    imageBrowsCollection.backgroundColor = [UIColor whiteColor];
    
    imageBrowsCollection.dataSource = self;
    imageBrowsCollection.delegate = self;
    
    imageBrowsCollection.pagingEnabled = YES;
    
    
    [imageBrowsCollection registerClass:[ZJBigImageCollectionViewCell class] forCellWithReuseIdentifier:@"ZJBigImageCollectionViewCell"];

    [self.view addSubview:imageBrowsCollection];
    [imageBrowsCollection makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    
    _indexPath = _currendIndexPath;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 72;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJBigImageCollectionViewCell" forIndexPath:indexPath];
    
    [cell setImage:[UIImage imageNamed:[NSString stringWithFormat: @"_%lu.jpg",indexPath.item]]];
    
    if (_currendIndexPath)
    {
        [collectionView scrollToItemAtIndexPath:_currendIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _currendIndexPath = nil;
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
    _indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                        animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    //如果是push就传点击小图时的那张图，如果是pop就传返回时的那张图
    NSInteger index  = operation == UINavigationControllerOperationPush ? self.currendIndexPath.item : _indexPath.item;
    
    return [ZJNavTransition transitionWithType:operation == UINavigationControllerOperationPush ? ZJNavTransitionPush : ZJNavTransitionPop WithImage:[UIImage imageNamed:[NSString stringWithFormat: @"_%lu.jpg",index]]];
}

@end
