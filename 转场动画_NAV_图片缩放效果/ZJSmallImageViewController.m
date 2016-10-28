//
//  ZJSmallImageViewController.m
//  转场动画_NAV_图片缩放效果
//
//  Created by 周君 on 16/10/4.
//  Copyright © 2016年 周君. All rights reserved.
//

#import "ZJSmallImageViewController.h"
#import "ZJSmallImageCollectionViewCell.h"
#import "ZJBigImageViewController.h"
#import "GlobalDefine.h"
#import "Masonry.h"

@interface ZJSmallImageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ZJSmallImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建一个布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //设置为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置每一块的大小
    //可以通过代理给每一项设置大小
    CGFloat itemWidth = (SCREENWIDTH - 6) / 4;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = (CGSize){itemWidth, itemHeight};
    
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 1;
    
    UICollectionView *smallCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    
    smallCollectionView.backgroundColor = [UIColor clearColor];
    //设置代理
    smallCollectionView.dataSource = self;
    smallCollectionView.delegate = self;
    
    [smallCollectionView registerClass:[ZJSmallImageCollectionViewCell class] forCellWithReuseIdentifier:@"ZJSmallImageCollectionViewCell"];
    
    [self.view addSubview:smallCollectionView];
    
    [smallCollectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 72;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJSmallImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJSmallImageCollectionViewCell" forIndexPath:indexPath];
    [cell setValueWithImage:[UIImage imageNamed:[NSString stringWithFormat: @"_%lu.jpg",indexPath.item]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJBigImageViewController *bigVC = [[ZJBigImageViewController alloc] init];
    //这里记得让大图成为小图navigation的代理
    self.navigationController.delegate = bigVC;
    bigVC.currendIndexPath = indexPath;
    [self.navigationController pushViewController:bigVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
