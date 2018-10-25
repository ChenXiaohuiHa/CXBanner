//
//  CXBannerView.h
//  CXBanner
//
//  Created by 陈晓辉 on 2018/10/25.
//  Copyright © 2018年 陈晓辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXBannerView : UIView

/** 图片的圆角半径 */
@property (nonatomic, assign) CGFloat imageRadius;
/** 图片高度差(中间与两侧高度差) 默认0 */
@property (nonatomic, assign) CGFloat imageHeightPoor;
/** 设置两侧图片透明度, 初始alpha默认1 */
@property (nonatomic, assign) CGFloat initAlpha;


/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;
/** 当前小圆点颜色 */
@property (nonatomic, strong) UIColor *currentPageControlColor;
/** 其余小圆点颜色  */
@property (nonatomic, strong) UIColor *otherPageControlColor;


/** 占位图*/
@property (nonatomic, strong) UIImage *placeHolderImage;
/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property (nonatomic, assign) BOOL hidesForSinglePage;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** 是否自动滚动,默认Yes */
@property (nonatomic, assign) BOOL autoScroll;


/** 数据源 */
@property (nonatomic, strong) NSArray *imageArray;
/** 点击中间图片的回调 */
@property (nonatomic, copy) void(^clickImageBlock)(NSInteger currentIndex);


/**
 初始化轮播 view
 
 @param frame 控件坐标
 @param imageSpacing 图片间距
 @param imageWidth 图片宽度
 */
+ (instancetype)initWithFrame:(CGRect)frame
                 imageSpacing:(CGFloat)imageSpacing
                   imageWidth:(CGFloat)imageWidth;

/**
 初始化轮播 + 数据数组 view
 
 @param frame 控件坐标
 @param imageSpacing 图片间距
 @param imageWidth 图片宽度
 @param imageArray 轮播图片数据数组
 */
+ (instancetype)initWithFrame:(CGRect)frame
                 imageSpacing:(CGFloat)imageSpacing
                   imageWidth:(CGFloat)imageWidth
                   imageArray:(NSArray *)imageArray;

@end

NS_ASSUME_NONNULL_END
