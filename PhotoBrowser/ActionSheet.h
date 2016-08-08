//
//  ActionSheet.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import <UIKit/UIKit.h>

@class ActionSheet;
@protocol ActionSheetDelegate <NSObject>
@optional
- (void)actionSheetRemovedFromSuperView:(ActionSheet *)actionSheet;
- (void)actionSheetCancel:(ActionSheet *)actionSheet;
@required
- (void)actionSheet:(ActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex;

@end
@interface ActionSheet : UIView
@property (nonatomic,weak) id<ActionSheetDelegate> delegate;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *cancelButtonTitle;
/**
 *  初始化 ActionSheet
 *
 *  @param title             标题
 *  @param delegate          代理
 *  @param cancelButtonTitle 完成按钮
 *  @param otherButtonTitles 其他的
 *
 *  @return ActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<ActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... ;
/**
 *  初始化 ActionSheet 数组
 *
 *  @param title              标题
 *  @param delegate          代理
 *  @param cancelButtonTitle 完成按钮
 *  @param array             其他的数组
 *
 *  @return                   ActionSheet
 */
- (instancetype)initWithTitle:(NSString *)title delegate:(id<ActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitleArray:(NSArray<NSString *>*)array;
- (void)show;

/**
 * 隐藏sheeet.
 */
- (void)hide;

/**
 * 设置标题的字体和颜色
 *
 *  @param color 颜色默认 black
 *  @param size  字体默认 15
 */
- (void)setTitleColor:(UIColor *)color FontSize:(CGFloat)size;

// Set the title color, background color and font size of button at index. Default the ttitle color is black, background color is white and font size is 14.
/**
 * 设置button的字体和颜色
 *
 *  @param color           颜色默认 black
 *  @param backgroundColor 颜色默认 white
 *  @param size            字体默认 14
 *  @param index           从第几个开始
 */
- (void)setButtonTitleColor:(UIColor *)color BackgroundColor:(UIColor *)backgroundColor FontSize:(CGFloat)size atIndex:(int)index;
/**
 * 设置完成的字体和颜色
 *
 *  @param color 颜色默认 black
 *  @param size  字体默认 14
 */
- (void)setCancelButtonTitleColor:(UIColor *)color BackgroundColor:(UIColor *)backgroundColor FontSize:(CGFloat)size;

@end



