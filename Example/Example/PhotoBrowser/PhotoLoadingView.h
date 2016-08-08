//
//  PhotoLoadingView.h
///  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kMinProgress 0.0001

@class PhotoBrowser;
@class Photo;

@interface PhotoLoadingView : UIView
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure;
@end