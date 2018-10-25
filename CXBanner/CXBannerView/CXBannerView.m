//
//  CXBannerView.m
//  CXBanner
//
//  Created by 陈晓辉 on 2018/10/25.
//  Copyright © 2018年 陈晓辉. All rights reserved.
//

#import "CXBannerView.h"
#import "UIView+Banner.h"
#import "UIImageView+WebCache.h"

#define CXMainScrollViewWidth self.mainScrollView.frame.size.width
#define CXMainScrollViewHeight self.mainScrollView.frame.size.height
@interface CXBannerView ()<UIScrollViewDelegate>

/** 页码指示器 */
@property (nonatomic, strong) UIPageControl *pageControl;
/** 滚动条 */
@property (nonatomic, strong) UIScrollView *mainScrollView;
/** 左边图片 */
@property (nonatomic, strong) UIImageView *leftImgView;
/** 中间图片 */
@property (nonatomic, strong) UIImageView *centerImgView;
/** 左边图片 */
@property (nonatomic, strong) UIImageView *rightImgView;
/** 当前(中间)图片索引 */
@property (nonatomic, assign) NSInteger currentImgIndex;
/** 图片宽度 */
@property (nonatomic, assign) CGFloat imgWidth;
/** 图片间距 */
@property (nonatomic, assign) CGFloat imageSpacing;
/** 图片数量 */
@property (nonatomic, assign) NSInteger imgCount;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;

@end
@implementation CXBannerView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgWidth = CXMainScrollViewWidth;
        [self initialization];
        [self setUpUI];
    }
    return self;
}

+ (instancetype)initWithFrame:(CGRect)frame
                 imageSpacing:(CGFloat)imageSpacing
                   imageWidth:(CGFloat)imageWidth {
    
    return [self initWithFrame:frame imageSpacing:imageSpacing imageWidth:imageWidth imageArray:@[]];
}
+ (instancetype)initWithFrame:(CGRect)frame
                 imageSpacing:(CGFloat)imageSpacing
                   imageWidth:(CGFloat)imageWidth
                   imageArray:(NSArray *)imageArray {
    
    CXBannerView *bannerView = [[self alloc] initWithFrame:frame];
    bannerView.imgWidth = imageWidth;
    bannerView.imageSpacing = imageSpacing;
    bannerView.imageArray = imageArray;
    return bannerView;
}

#pragma mark - 配置默认信息
- (void)initialization {
    
    _initAlpha = 1;
    _autoScrollTimeInterval = 2.0;
    _imageHeightPoor = 0;
    _showPageControl = YES;
    _hidesForSinglePage = YES;
    _autoScroll = YES;
    self.currentPageControlColor = [UIColor redColor];
    self.otherPageControlColor = [UIColor whiteColor];
    self.imageArray = [NSArray array];
}
#pragma mark - 设置 UI
- (void)setUpUI {
    
    //scrollView
    self.mainScrollView = [self createMainScrollView];
    
    //图片视图: 左边
    self.leftImgView = [self createImageView];
    [self.leftImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftImgTaoGes)]];
    [self.mainScrollView addSubview:self.leftImgView];
    
    //图片视图: 中间
    self.centerImgView = [self createImageView];
    [self.centerImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerImgTaoGes)]];
    [self.mainScrollView addSubview:self.centerImgView];
    
    //图片视图: 右边
    self.rightImgView = [self createImageView];
    [self.rightImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightImgTaoGes)]];
    [self.mainScrollView addSubview:self.rightImgView];
    
    //更新控件坐标
    [self updateViewFrameSetting];
}

#pragma mark - 设置图片显示初始尺寸
- (void)updateViewFrameSetting {
    
    //设置滚动视图 偏移量
    self.mainScrollView.contentSize = CGSizeMake(CXMainScrollViewWidth *3, CXMainScrollViewHeight);
    self.mainScrollView.contentOffset = CGPointMake(CXMainScrollViewWidth, 0.0);
    //图片视图: 左边
    self.leftImgView.frame = CGRectMake(self.imageSpacing/2, self.imageHeightPoor, self.imgWidth, (CXMainScrollViewHeight -self.imageHeightPoor *2));
    //图片视图: 中间
    self.centerImgView.frame = CGRectMake((CXMainScrollViewWidth +self.imageSpacing/2), 0.0, self.imgWidth, CXMainScrollViewHeight);
    //图片视图: 右边
    self.rightImgView.frame = CGRectMake((CXMainScrollViewWidth *2.0 +self.imageSpacing/2), self.imageHeightPoor, self.imgWidth, (CXMainScrollViewHeight -self.imageHeightPoor *2));
}

#pragma mark ---------- setter 方法 ----------
//设置中间图片与两侧高度差, 同时更新坐标
- (void)setImageHeightPoor:(CGFloat)imageHeightPoor {
    
    _imageHeightPoor = imageHeightPoor;
    [self updateViewFrameSetting];
}
//设置图片圆角
- (void)setImageRadius:(CGFloat)imageRadius {
    
    _imageRadius = imageRadius;
    [self.leftImgView addRoundedCornersWithRadius:imageRadius];
    [self.centerImgView addRoundedCornersWithRadius:imageRadius];
    [self.rightImgView addRoundedCornersWithRadius:imageRadius];
    [self.leftImgView addShadowOpacityWithProjection:0.4];
    [self.centerImgView addShadowOpacityWithProjection:0.4];
    [self.rightImgView addShadowOpacityWithProjection:0.4];
}
//设置数据源
- (void)setImageArray:(NSArray *)imageArray {
    
    //对比原数据与新数据
    if (imageArray.count < _imageArray.count) {
        [_mainScrollView setContentOffset:CGPointMake(CXMainScrollViewWidth, 0) animated:NO];
    }
    
    _imageArray =imageArray;
    
    self.currentImgIndex = 0;
    self.imgCount = imageArray.count;
    self.pageControl.numberOfPages = self.imgCount;
    [self setInfoByCurrentImageIndex:self.currentImgIndex];
    
    if (imageArray.count != 1) {
        
        self.mainScrollView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    }else{
        
        [self invalidateTimer];
        // CXMainScrollViewWidth < self.frame.size.width    这样的 说明是 图片有间距 卡片 翻页效果那种布局
        self.mainScrollView.scrollEnabled = CXMainScrollViewWidth < self.frame.size.width ? YES : NO;
    }
    
    [self createPageControl];
}
//根据 图片间距, 重新布局 显示图片 的坐标
- (void)setImageSpacing:(CGFloat)imageSpacing {
    
    _imageSpacing = imageSpacing;
    self.mainScrollView.frame = CGRectMake((CXMainScrollViewWidth -(self.imgWidth +imageSpacing))/2, 0, self.imgWidth +imageSpacing, CXMainScrollViewHeight);
    [self updateViewFrameSetting];
}
//设置页码指示器 当前页颜色
- (void)setCurrentPageControlColor:(UIColor *)currentPageControlColor {
    
    _currentPageControlColor = currentPageControlColor;
    _pageControl.currentPageIndicatorTintColor = currentPageControlColor;
}
//设置页码指示器 其他页颜色
- (void)setOtherPageControlColor:(UIColor *)otherPageControlColor {
    
    _otherPageControlColor = otherPageControlColor;
    _pageControl.pageIndicatorTintColor = otherPageControlColor;
}
//自动滚动间隔时间
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}
//是否自动滚动
- (void)setAutoScroll:(BOOL)autoScroll {
    
    _autoScroll = autoScroll;
    [self invalidateTimer];
    if (_autoScroll) { // YES 开启定时器
        
        [self createTimer];
    }
}
//设置占位图片
- (void)setPlaceHolderImage:(UIImage *)placeHolderImage {
    
    _placeHolderImage = placeHolderImage;
    self.leftImgView.image = placeHolderImage;
    self.centerImgView.image = placeHolderImage;
    self.rightImgView.image = placeHolderImage;
}
//是否显示 页码指示器
-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}
//设置两侧图片的透明度
- (void)setInitAlpha:(CGFloat)initAlpha {
    _initAlpha = initAlpha;
    self.leftImgView.alpha = self.initAlpha;
    self.centerImgView.alpha = 1;
    self.rightImgView.alpha = self.initAlpha;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
//    if (self.autoScroll) {
//        
//        [self invalidateTimer];
//    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self reloadImage];
    [self.mainScrollView setContentOffset:CGPointMake(CXMainScrollViewWidth, 0) animated:NO];
    self.pageControl.currentPage = self.currentImgIndex;
    
    //[self reloadImage];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    if (self.autoScroll) {
//
//         [self invalidateTimer];
//    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.imageSpacing > 0) {
        
        CGFloat currentX = scrollView.contentOffset.x -CXMainScrollViewWidth;//当前图片 x 值
        CGFloat gradientAlpha = currentX/CXMainScrollViewWidth *(1 -self.initAlpha);//过度透明渐变
        CGFloat variableH = currentX/CXMainScrollViewWidth *self.imageHeightPoor *2;//过度高度差
        
        if (currentX > 0) { //左滑
            
            self.centerImgView.alpha = 1 -gradientAlpha;//中间图片逐渐透明
            self.rightImgView.alpha = self.initAlpha +gradientAlpha;//右侧图片逐渐清晰
            self.centerImgView.height = CXMainScrollViewHeight -variableH;//根据高度差,中间图片设为两侧高度
            self.centerImgView.y = currentX/CXMainScrollViewWidth *self.imageHeightPoor;
            self.rightImgView.height = CXMainScrollViewHeight -self.imageHeightPoor *2 +variableH;
            self.rightImgView.y = self.imageHeightPoor -currentX/CXMainScrollViewWidth *self.imageHeightPoor;
        }else if (currentX < 0) { //右滑
            
            self.centerImgView.alpha = 1 +gradientAlpha;//中间图片逐渐透明
            self.leftImgView.alpha = self.initAlpha -gradientAlpha;//左侧图片逐渐清晰
            self.centerImgView.height = CXMainScrollViewHeight +variableH;//根据高度差,中间图片设为两侧高度
            self.centerImgView.y = currentX/CXMainScrollViewWidth *self.imageHeightPoor;
            self.leftImgView.height = CXMainScrollViewHeight -self.imageHeightPoor *2 -variableH;
            self.leftImgView.y = self.imageHeightPoor +currentX/CXMainScrollViewWidth *self.imageHeightPoor;
        }else{
            
            self.leftImgView.alpha = self.initAlpha;
            self.centerImgView.alpha = 1;
            self.rightImgView.alpha = self.initAlpha;
            self.leftImgView.height = CXMainScrollViewHeight -self.imageHeightPoor*2;
            self.centerImgView.height = CXMainScrollViewHeight;
            self.rightImgView.height = CXMainScrollViewHeight -self.imageHeightPoor*2;
            self.leftImgView.y = self.imageHeightPoor;
            self.centerImgView.y = 0;
            self.rightImgView.y = self.imageHeightPoor;
        }
    }
}
//
- (void)reloadImage {
    
    //~~ 避免0
    if(self.imgCount == 0) {
        return;
    }
    
    CGPoint contentOffset = [self.mainScrollView contentOffset];
    if (contentOffset.x > CXMainScrollViewWidth) { //向左滑动
        
        _currentImgIndex = (_currentImgIndex +1) % self.imgCount;
    }else if (contentOffset.x < CXMainScrollViewWidth) { //向右滑动
        
        _currentImgIndex = (_currentImgIndex -1 +self.imgCount) % self.imgCount;
    }
    
    [self setInfoByCurrentImageIndex:_currentImgIndex];
}
// 设置图片
- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex {
    
    if (self.imgCount == 0) {
        return;
    }
    
    //图片显示: 中间
    if ([self isHttpString:self.imageArray[currentImageIndex]]) {
        
        [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[currentImageIndex]] placeholderImage:self.placeHolderImage];
    }else{
        
        self.centerImgView.image = self.imageArray[currentImageIndex];
    }
    
    //图片显示: 左边
    NSInteger leftIndex = (currentImageIndex -1 +self.imgCount) % self.imgCount;
    if ([self isHttpString:self.imageArray[leftIndex]]) {
        
        [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[leftIndex]] placeholderImage:self.placeHolderImage];
    }else{
        
        self.leftImgView.image = self.imageArray[leftIndex];
    }
    
    //图片显示: 右边
    NSInteger rightIndex = (currentImageIndex +1) % self.imgCount;
    if ([self isHttpString:self.imageArray[rightIndex]]) {
        
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[rightIndex]] placeholderImage:self.placeHolderImage];
    }else{
        
        self.rightImgView.image = self.imageArray[rightIndex];
    }
    
    _pageControl.currentPage = currentImageIndex;
}

#pragma mark ---------- Other Method ----------

//创建 滚动视图
- (UIScrollView *)createMainScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    return scrollView;
}
- (UIImageView *)createImageView {
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.userInteractionEnabled = YES;
    
    return imgView;
}
//创建页码指示器
- (void)createPageControl {
    
    if (_pageControl) [_pageControl removeFromSuperview];
    if (self.imageArray.count == 0) return;
    if (self.imageArray.count == 1 && self.hidesForSinglePage) return;
    
    //
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-200)/2, CXMainScrollViewHeight -30, 200, 30)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = self.imageArray.count;
    _pageControl.currentPageIndicatorTintColor = self.currentPageControlColor;
    _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    [self addSubview:_pageControl];
    
    _pageControl.hidden = !_showPageControl;
}

//判断字符串 是否是 http/https 开头
-(BOOL)isHttpString:(NSString *)urlStr {
    
    if ([urlStr hasPrefix:@"http:"] || [urlStr hasPrefix:@"https:"]) {
        
        return YES;
    }else{
        
        return NO;
    }
}

#pragma mark - 定时器
- (void)createTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}
- (void)automaticScroll {
    
    if (_imgCount == 0) return;
    if (self.mainScrollView.scrollEnabled == NO) return;
    
    [self.mainScrollView setContentOffset:CGPointMake(CXMainScrollViewWidth *2, 0) animated:YES];
}

- (void)invalidateTimer {
    
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - life circles
//解决当父视图 view 释放的时候, 当前视图因为被 定时器timer 强引用儿不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (!newSuperview) {
        
        [self invalidateTimer];
    }
}
//解决当 定时器timer 释放后 回调 scrollViewDidScrill 时, 访问野指针导致崩溃
- (void)dealloc {
    
    _mainScrollView.delegate = nil;
    [self invalidateTimer];
}

#pragma mark -- action
- (void)leftImgTaoGes{
    NSLog(@"leftImgTaoGes");
}
- (void)centerImgTaoGes{
    NSLog(@"centerImgTaoGes");
    if (self.clickImageBlock) {
        
        self.clickImageBlock(self.currentImgIndex);
    }
}
- (void)rightImgTaoGes{
    NSLog(@"rightImgTaoGes");
}

@end
