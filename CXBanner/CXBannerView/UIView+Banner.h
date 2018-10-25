//
//  UIView+Banner.h
//  HWBannerDemo
//
//  Created by Junn on 2018/1/24.
//  Copyright © 2018年 Junn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Banner)

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;


/**
 给 视图view 添加阴影

 @param shadowOpacity 阴影透明度, 默认 0
 */
- (void)addShadowOpacityWithProjection:(CGFloat)shadowOpacity;

/**
 给 视图view 添加边框

 @param width 边框宽度
 */
- (void)addBorderWithWidth:(CGFloat)width;

/**
 给 视图view 添加边框 和 边框颜色

 @param width 边框宽度
 @param borderColor 边框颜色
 */
- (void)addBorderWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor;

/**
 给 视图view 四角 添加圆角

 @param radius 圆角半径
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius;

/**
 给 视图view 一角 添加圆角

 @param radius 圆角半径
 @param corners 切哪个角
 typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
 UIRectCornerTopLeft,
 UIRectCornerTopRight ,
 UIRectCornerBottomLeft,
 UIRectCornerBottomRight,
 UIRectCornerAllCorners
 };
 使用案例:[self.mainView addRoundedCornersWithRadius:10 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight]; // 切除了左下 右下
 */
- (void)addRoundedCornersWithRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners;

@end
