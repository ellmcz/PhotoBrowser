//
//  PhotoBrowser.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@protocol PhotoBrowserDelegate;
@interface PhotoBrowser : UIViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<PhotoBrowserDelegate> delegate;
#pragma mark ---------------------  必选  ---------------------------
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
#pragma mark ---------------------  可选  ---------------------------
/// 一般不建议使用 只有photoBrowserTopType（PhotoBrowserTopSettingType,PhotoBrowserTopCustomType）使用。
@property (nonatomic, assign,getter=isDispaly) BOOL dispaly;
// 显示

- (void)show;
@end

@protocol PhotoBrowserDelegate <NSObject>
@optional
/**
 *  监听改变页面
 *
 *  @param photoBrowser 本身
 *  @param index        改变到页面
 */
- (void)photoBrowser:(PhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
/**
 *   不跳转页面的操作
 *
 *  @param photoBrowser 本身
 *  @param index        索引
 */
- (void)photoBrowser:(PhotoBrowser *)photoBrowser index:(NSUInteger)index;
/**
 * 跳转页面的操作
 *
 *  @param photoBrowser 本身
 *  @param index        索引
 */
- (void)photoBrowser:(PhotoBrowser *)photoBrowser Actionindex:(NSUInteger)index;
/**
 *  进入下一个页面
 *
 *  @param photoBrowser 本身
 *  @param photos       Photo数组模型
 */
- (void)photoBrowser:(PhotoBrowser *)photoBrowser Photos:(NSArray *)photos;


@end