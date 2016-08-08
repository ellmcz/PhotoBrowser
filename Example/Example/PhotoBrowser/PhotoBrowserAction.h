//
//  PhotoBrowserAction.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import <Foundation/Foundation.h>
#import  "Singleton.h"
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,PhotoBrowserType){
    PhotoBrowserLabelNormalType=0,
    PhotoBrowserLabelType,
    PhotoBrowserPageNormalType,
    PhotoBrowserPageType
};
typedef NS_ENUM(NSUInteger,PhotoBrowserTopType) {
    PhotoBrowserTopNormalType=0,
    PhotoBrowserTopSettingType,
    PhotoBrowserTopCustomType,
};
@interface PhotoBrowserAction : NSObject
Singleton_h(PhotoBrowserAction)
@property (nonatomic,strong,readonly) NSString *title;
@property (nonatomic,strong,readonly) NSString *cancelButtonTitle;
@property (nonatomic,strong,readonly) NSMutableArray *buttonTitleArray;
@property (nonatomic,strong,readonly)UIColor  *titleColor;
@property (nonatomic,assign,readonly)CGFloat  titleFont;
@property (nonatomic,strong,readonly)UIColor  *buttonTitleColor;
@property (nonatomic,assign,readonly)CGFloat  buttonTitleFont;
@property (nonatomic,strong,readonly)UIColor  *cancelButtonTitleColor;
@property (nonatomic,assign,readonly)CGFloat  cancelButtonTitleFont;
@property (nonatomic,assign,readonly)NSUInteger index;
@property (nonatomic,assign,readonly)NSUInteger index1;
@property (nonatomic,assign,readonly)PhotoBrowserType photoBrowserType;
@property (nonatomic,strong,readonly)UIColor  *pageCurrentColor;
@property (nonatomic,strong,readonly)UIColor  *pageOtherColor;
@property (nonatomic,copy,readonly)NSString  *productName;
@property (nonatomic,assign,readonly)BOOL  isTag;
@property (nonatomic,assign,readonly)BOOL  isIndex;
@property (nonatomic,assign,readonly)NSUInteger saveImageIndex;
@property (nonatomic, assign,readonly)PhotoBrowserTopType photoBrowserTopType;
/**
 *  设置ActionSheet的数据
 *
 *  @param title             标题
 *  @param cancelButtonTitle 完成按钮的字
 *  @param otherButtonTitles button的文字（必须以nil结束）
 */
- (void)settingPhotoBrowserActionWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;
/**
 *  设置标题的属性
 *
 *  @param color 颜色
 *  @param font  字体
 */
- (void)settingTitleColor:(UIColor *)color FontSize:(CGFloat)font;
/**
 *  设置button的属性
 *
 *  @param color 颜色
 *  @param font  字体
 */
- (void)settingButtonTitleColor:(UIColor *)color FontSize:(CGFloat)font ;
/**
 *  设置完成button的属性
 *
 *  @param color 颜色
 *  @param font  字体
 */
- (void)settingCancelButtonTitleColor:(UIColor *)color FontSize:(CGFloat)font;
/**
 *  设置页面跳转（一个参数，如果传二个参数使用下面一个）
 *
 *  @param index 所在文字的索引
 */
- (void)settingActionIndex:(NSUInteger)index;
/**
 * 设置页面跳转
 *
 *  @param index  所在文字的索引1
 *  @param index1 所在文字的索引2
 */
- (void)settingActionIndex:(NSUInteger)index Index1:(NSUInteger)index1;
/**
 *  设置photoBrowser的类型
 *
 *  @param photoBrowserType 设置photoBrowser的类型
 */
- (void)settingWithPhotoBrowserType:(PhotoBrowserType)photoBrowserType PhotoBrowserTopType:(PhotoBrowserTopType)photoBrowserTopType;
/**
 *  如果你设置PhotoBrowserPageNormalType,PhotoBrowserPageType，需要设置
 *
 *  @param pageCurrentColor 当前pageControl的颜色
 *  @param pageOtherColor   其他pageControl的颜色
 */
- (void)settingPageCurrentColor:(UIColor *)pageCurrentColor PageOtherColor:(UIColor *)pageOtherColor;
/**
 *  自定义相册（中文）
 *
 *  @param productName 相册的名字
 */
- (void)setingChineseProductName:(NSString *)productName;
/**
 * 自定义相册 （英文）
 */
- (void)setingEnginProductName;
/**
 *  保存图片ActionSheet设置
 *
 *  @param index 所在的索引
 */
- (void)settingSaveImageIndex:(NSUInteger)index;
@end
