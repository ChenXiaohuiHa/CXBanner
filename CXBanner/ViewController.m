//
//  ViewController.m
//  CXBanner
//
//  Created by 陈晓辉 on 2018/10/25.
//  Copyright © 2018年 陈晓辉. All rights reserved.
//

#import "ViewController.h"
#import "CXBannerView/CXBannerView.h"

#define KScreenWidth self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self kapianBanner];
    [self normalBanner];
}
#pragma mark - 卡片滚动图
- (void)kapianBanner {
    
    CXBannerView *bannerView = [CXBannerView initWithFrame:CGRectMake(0, 100, KScreenWidth, 150) imageSpacing:10 imageWidth:KScreenWidth - 50];
    bannerView.initAlpha = 0.5; // 设置两边卡片的透明度
    bannerView.imageRadius = 10; // 设置卡片圆角
    bannerView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
    // 设置要加载的图片
    bannerView.imageArray = @[@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",@"http://img3.3lian.com/2013/c3/80/d/2.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://img1.3lian.com/2015/a1/79/d/73.jpg"];
    bannerView.placeHolderImage = [UIImage imageNamed:@"m1.jpg"]; // 设置占位图片
    [self.view addSubview:bannerView];
    bannerView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
        
        //点击回调
        NSLog(@"点击了第 %ld 张图片",currentIndex);
    };
}

#pragma mark - 普通滚动图
- (void)normalBanner {
    
    CXBannerView *bannerView = [CXBannerView initWithFrame:CGRectMake(0, 300, KScreenWidth, 150) imageSpacing:0 imageWidth:KScreenWidth];
    bannerView.placeHolderImage = [UIImage imageNamed:@"m1.jpg"]; // 设置占位图片
    bannerView.imageArray = @[@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",@"http://img3.3lian.com/2013/c3/80/d/2.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://img1.3lian.com/2015/a1/79/d/73.jpg"];
    [self.view addSubview:bannerView];
    
    bannerView.clickImageBlock = ^(NSInteger currentIndex) {
        
        //点击回调
        NSLog(@"点击了第 %ld 张图片",currentIndex);
    };
}


@end
