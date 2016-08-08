//
//  PhotoView.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "PhotoView.h"
#import "ActionSheet.h"
#import "PhotoLoadingView.h"
#import "Photo.h"
#import "PhotoBrowserAction.h"
#import "UIImageView+WebCache.h"
@interface PhotoView ()<ActionSheetDelegate>

@property (nonatomic, assign ,getter=isDoubleTap) BOOL doubleTap;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) PhotoLoadingView *photoLoadingView;

@end

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView=imageView;
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        PhotoLoadingView *photoLoadingView = [[PhotoLoadingView alloc] init];
        self.photoLoadingView=photoLoadingView;
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
  
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
            BOOL isType=[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserLabelType||[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserPageType;
      
        if (isType) {
            UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImagelongPress:)];
            
            [self addGestureRecognizer:longPress];

        }
           }
    return self;
}

#pragma mark - photosetter
- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    if (_photo.isFirstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
        _photo.sourceImageView.image = nil;
        
        // 不是gif，就马上开始下载
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            __unsafe_unretained PhotoView *photoView = self;
            __unsafe_unretained Photo *photo = _photo;
            [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.placeholder options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                photo.image = image;
                // 调整frame参数
                [photoView adjustFrame];
            }];

        }
    } else {
        [self photostartLoad];
    }

    // 调整frame参数
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photostartLoad
{
    if (_photo.image) {        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        __unsafe_unretained PhotoView *photoView = self;
        __unsafe_unretained PhotoLoadingView *loading = _photoLoadingView;
        [_imageView sd_setImageWithURL:_photo.url placeholderImage:_photo.sourceImageView.image options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize , NSInteger expectedSize) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (receivedSize > kMinProgress) {
                    loading.progress = receivedSize*1.0/expectedSize;
                    NSLog(@"%f",loading.progress);
                }
            });
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType , NSURL *imageUrl) {
            
            [photoView photoDidFinishLoadWithImage:image];
        }];

    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 3.0;
	if ([UIScreen  instanceMethodForSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    
    if (_photo.isFirstShow) { // 第一次显示的图片
        _photo.isFirstShow = NO; // 已经显示过了
        _imageView.frame = [_photo.sourceImageView convertRect:_photo.sourceImageView.bounds toView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.sourceImageView.image = _photo.placeholder;
            [self photostartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageViewFrame = _imageView.frame;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (imageViewFrame.size.height > screenBounds.size.height) {
        imageViewFrame.origin.y = 0.0f;
    } else {
        imageViewFrame.origin.y = (screenBounds.size.height - imageViewFrame.size.height) / 2.0;
    }
    _imageView.frame = imageViewFrame;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)hide
{
    if (self.isDoubleTap) return;
    // 移除进度条
    [_photoLoadingView removeFromSuperview];
    self.contentOffset = CGPointZero;
    // 清空底部的小图
    _photo.sourceImageView.image = nil;
    
    CGFloat duration = 0.15;
    if (_photo.sourceImageView.clipsToBounds) {
        [self performSelector:@selector(reset) withObject:nil afterDelay:duration];
    }
    
    [UIView animateWithDuration:duration + 0.1 animations:^{
        _imageView.frame = [_photo.sourceImageView convertRect:_photo.sourceImageView.bounds toView:nil];
        // gif图片仅显示第0张
        if (_imageView.image.images) {
            _imageView.image = _imageView.image.images[0];
        }
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
            [self.photoViewDelegate photoViewSingleTap:self];
        }
    } completion:^(BOOL finished) {
        // 设置底部的小图片
        _photo.sourceImageView.image = _photo.placeholder;
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    }];
}
- (void)dismiss{
    if (self.isDoubleTap) return;
    // 移除进度条
   [_photoLoadingView removeFromSuperview];
    
    CGFloat duration = 0.15;
    [UIView animateWithDuration:duration + 0.1 animations:^{
        // 设置底部的小图片
        _photo.sourceImageView.image = _photo.placeholder;
        // 通知代理
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
            [self.photoViewDelegate photoViewDidEndZoom:self];
        }
    } completion:^(BOOL finished) {
        
    }];
}
- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    self.doubleTap=YES;
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}
- (void)saveImagelongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state==UIGestureRecognizerStateBegan) {
       
        ActionSheet *sheet =[[ActionSheet alloc]initWithTitle:[PhotoBrowserAction sharedPhotoBrowserAction].title delegate:self cancelButtonTitle:[PhotoBrowserAction sharedPhotoBrowserAction].cancelButtonTitle otherButtonTitleArray:[PhotoBrowserAction sharedPhotoBrowserAction].buttonTitleArray];
        [sheet setTitleColor:[PhotoBrowserAction sharedPhotoBrowserAction].titleColor FontSize:[PhotoBrowserAction sharedPhotoBrowserAction].titleFont];
        [sheet setButtonTitleColor:[PhotoBrowserAction sharedPhotoBrowserAction].buttonTitleColor BackgroundColor:[UIColor whiteColor] FontSize:[PhotoBrowserAction sharedPhotoBrowserAction].buttonTitleFont atIndex:1];
        [sheet setCancelButtonTitleColor:[PhotoBrowserAction sharedPhotoBrowserAction].cancelButtonTitleColor BackgroundColor:[UIColor whiteColor] FontSize:[PhotoBrowserAction sharedPhotoBrowserAction].cancelButtonTitleFont];
        [sheet show];    
    }
}
- (void)actionSheet:(ActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    if ([self.photoViewDelegate respondsToSelector:@selector(photoView:index:)]) {
        [self.photoViewDelegate photoView:self index:buttonIndex];
        
    }
}

- (void)dealloc
{
    // 取消请求
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}
@end