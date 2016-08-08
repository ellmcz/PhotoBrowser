//
//  Photo.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Photo : NSObject
#pragma mark --------------------- 必选  ---------------------------
/// 图片URL
@property (nonatomic, strong) NSURL *url;
///  来源view
@property (nonatomic, strong) UIImageView *sourceImageView;
#pragma mark ---------------------  可选  ---------------------------
///  完整的图片
@property (nonatomic, strong) UIImage *image;
/// 图片的描述
@property (nonatomic, strong) NSString *photoDescription;
/// 占位图片
@property (nonatomic, strong, readonly) UIImage *placeholder;

@property (nonatomic, strong, readonly) UIImage *capture;
/// 是否第一次显示
@property (nonatomic, assign) BOOL isFirstShow;
/// 是否已经保存到相册
@property (nonatomic, assign) BOOL isSave;
///  索引
@property (nonatomic, assign) int index;
@end