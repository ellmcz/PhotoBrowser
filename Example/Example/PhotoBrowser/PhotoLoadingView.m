//
//  PhotoLoadingView.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "PhotoLoadingView.h"
#import "PhotoProgressView.h"
@interface PhotoLoadingView ()

@property (nonatomic, weak) UILabel *failureLabel;
@property (nonatomic, weak) PhotoProgressView *progressView;
@end

@implementation PhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[UIScreen mainScreen].bounds];
}

- (void)showFailure
{
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        self.failureLabel=label;
        self.failureLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, 44);
        self.failureLabel.textAlignment = NSTextAlignmentCenter;
        self.failureLabel.center = self.center;
        self.failureLabel.text = @"网络不给力，图片下载失败";
        self.failureLabel.font = [UIFont boldSystemFontOfSize:20];
        self.failureLabel.textColor = [UIColor whiteColor];
        self.failureLabel.backgroundColor = [UIColor clearColor];
        self.failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:self.failureLabel];
}

- (void)showLoading
{
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
       PhotoProgressView *progressView = [[PhotoProgressView alloc] init];
        self.progressView=progressView;
        self.progressView.bounds = CGRectMake( 0, 0, 60, 60);
        self.progressView.center = self.center;
    }
    self.progressView.progress = kMinProgress;
    [self addSubview:self.progressView];
}
#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    self.progressView.progress = progress;
    if (progress >= 1.0) {
        [self.progressView removeFromSuperview];
    }
}
@end
