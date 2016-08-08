//
//  PhotoBrowserAction.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "PhotoBrowserAction.h"

@interface PhotoBrowserAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray *buttonTitleArray;
@property (nonatomic, strong)UIColor  *titleColor;
@property (nonatomic, assign)CGFloat  titleFont;
@property (nonatomic, strong)UIColor  *buttonTitleColor;
@property (nonatomic, assign)CGFloat  buttonTitleFont;
@property (nonatomic, strong)UIColor  *cancelButtonTitleColor;
@property (nonatomic, assign)CGFloat  cancelButtonTitleFont;
@property (nonatomic, assign)NSUInteger index;
@property (nonatomic, assign)NSUInteger index1;
@property (nonatomic, assign,)PhotoBrowserType photoBrowserType;
@property (nonatomic, strong)UIColor *pageCurrentColor;
@property (nonatomic, strong)UIColor *pageOtherColor;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, assign)BOOL  isTag;
@property (nonatomic, assign)BOOL  isIndex;

@property (nonatomic, assign)NSUInteger saveImageIndex;
@property (nonatomic, assign)PhotoBrowserTopType photoBrowserTopType;
@end
@implementation PhotoBrowserAction
Singleton_m(PhotoBrowserAction)
- (instancetype)init{
    if (self=[super init]) {
        _saveImageIndex=-10;
        if (!_pageOtherColor) {
            _pageOtherColor=[UIColor whiteColor];
        }
        if (!_pageCurrentColor) {
            _pageCurrentColor=[UIColor redColor];
        }
    }
    if (!_photoBrowserType) {
        {
            _photoBrowserType=PhotoBrowserLabelNormalType;
        }
        
      if (!_index) {
            _isTag=NO;
        }
        if (!_index1) {
           
            _isIndex=NO;
        }
        if (!_productName) {
            _productName=nil;
        }
        if (!_photoBrowserTopType) {
            _photoBrowserTopType=PhotoBrowserTopNormalType;
        }
        
    }
    return self;
}

- (void)settingPhotoBrowserActionWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _buttonTitleArray = [NSMutableArray array];
        va_list args;
        va_start(args, otherButtonTitles);
        if (otherButtonTitles) {
            [_buttonTitleArray addObject:otherButtonTitles];
            while (1) {
                NSString *otherButtonTitle = va_arg(args, NSString *);
                if (otherButtonTitle == nil) {
                    break;
                } else {
                    [_buttonTitleArray addObject:otherButtonTitle];
                }
            }
        }
        va_end(args);
}
/**
 * 设置标题的字体和颜色
 *
 *  @param color 颜色默认 black
 *  @param size  字体默认 15
 */
- (void)settingTitleColor:(UIColor *)color FontSize:(CGFloat)font{
    _titleColor=color;
    _titleFont=font;
    
}

/**
 * 设置button的字体和颜色
 *
 *  @param color           颜色默认 black
 *  @param backgroundColor 颜色默认 white
 *  @param size            字体默认 14
 *  @param index           从第几个开始
 */
- (void)settingButtonTitleColor:(UIColor *)color FontSize:(CGFloat)font{
    _buttonTitleColor=color;
    _buttonTitleFont=font;
}
/**
 * 设置完成的字体和颜色
 *
 *  @param color 颜色默认 black
 *  @param size  字体默认 14
 */
- (void)settingCancelButtonTitleColor:(UIColor *)color FontSize:(CGFloat)font{
    _cancelButtonTitleColor=color;
    _buttonTitleFont=font;
}
-(void)settingActionIndex:(NSUInteger)index{
    if (!index) {
        _index=index;
        _isTag=YES;
    }
}
-(void)settingActionIndex:(NSUInteger)index Index1:(NSUInteger)index1{
    if (!index) {
        _index=index;
        _isTag=YES;
    }
    if (index1) {
        _index1=index1;
        _isIndex=YES;
        
    }
}
- (void)settingWithPhotoBrowserType:(PhotoBrowserType)photoBrowserType PhotoBrowserTopType:(PhotoBrowserTopType)photoBrowserTopType{
    if (photoBrowserType) {
        _photoBrowserType=photoBrowserType;
    }
    if (photoBrowserTopType) {
        _photoBrowserTopType=photoBrowserTopType;
    }
}
- (void)settingPageCurrentColor:(UIColor *)pageCurrentColor PageOtherColor:(UIColor *)pageOtherColor{
    if(pageCurrentColor){
        _pageCurrentColor=pageCurrentColor;
    }
    if (pageOtherColor) {
        _pageOtherColor=pageOtherColor;
    }
}
- (void)setingEnginProductName{
    _productName=[NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}
- (void)setingChineseProductName:(NSString *)productName{
    if(productName){
        _productName=productName;
    }
}
- (void)settingSaveImageIndex:(NSUInteger)index{
    if (index) {
    _saveImageIndex=index;
    
    }
}
@end
