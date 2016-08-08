//
//  IOSPhoto.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "Photo.h"
#import "PhotoHeader.h"
@implementation Photo

#pragma mark 截图
- (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setSourceImageView:(UIImageView *)sourceImageView
{
    _sourceImageView = sourceImageView;
    _placeholder = sourceImageView.image;
    if (sourceImageView.clipsToBounds) {
        _capture = [self capture:sourceImageView];
    }
}

@end