//
//  PhotoView.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import <UIKit/UIKit.h>

@class PhotoBrowser, Photo, PhotoView;

@protocol PhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(PhotoView *)photoView;
- (void)photoViewSingleTap:(PhotoView *)photoView;
- (void)photoViewDidEndZoom:(PhotoView *)photoView;
- (void)photoView:(PhotoView *)photoView index:(NSUInteger)index;
@end

@interface PhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) Photo *photo;
// 代理
@property (nonatomic, weak) id<PhotoViewDelegate> photoViewDelegate;
- (void)dismiss;
@end