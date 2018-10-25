//
//  UIView+Banner.m
//  HWBannerDemo
//
//  Created by Junn on 2018/1/24.
//  Copyright © 2018年 Junn. All rights reserved.
//

#import "UIView+Banner.h"

@implementation UIView (Banner)

#pragma mark - Frame
//x
- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x {
    
    return self.frame.origin.x;
}
//y
- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y {
    
    return self.frame.origin.y;
}
//centerX
- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX {
    
    return self.center.x;
}
//centerY
- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY {
    
    return self.center.y;
}
//width
- (void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width {
    
    return self.frame.size.width;
}
//height
- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height {
    
    return self.frame.size.height;
}
//size
- (void)setSize:(CGSize)size {
    
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size {
    
    return self.frame.size;
}
//origin
- (void)setOrigin:(CGPoint)origin {
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin {
    
    return self.frame.origin;
}
//top
- (void)setTop:(CGFloat)top {
    
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)top {
    
    return self.frame.origin.y;
}
//left
- (void)setLeft:(CGFloat)left {
    
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)left {
    
    return self.frame.origin.x;
}
//bottom
- (void)setBottom:(CGFloat)bottom {
    
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGFloat)bottom {
    
    return self.frame.origin.y + self.frame.size.height;
}
//right
- (void)setRight:(CGFloat)right {
    
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (CGFloat)right {
    
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - 快速添加阴影
- (void)addShadowOpacityWithProjection:(CGFloat)shadowOpacity {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor 阴影颜色
    self.layer.shadowOffset = CGSizeMake(0, 0);//shadowOffset阴影偏移,x向右偏移2，y向下偏移6，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowRadius = 3;//阴影半径, 默认 3
    self.layer.shadowOpacity = shadowOpacity;//阴影透明度, 默认 0
}
- (void)addBorderWithWidth:(CGFloat)width {
    
    self.layer.borderWidth = width;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
- (void)addBorderWithWidth:(CGFloat)width borderColor:(UIColor *)borderColor {
    
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
}
- (void)addRoundedCornersWithRadius:(CGFloat)radius {
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}
- (void)addRoundedCornersWithRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

@end
