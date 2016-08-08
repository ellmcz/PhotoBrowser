//
//  PhotoToolbar.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoToolbar : UIView
/// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
/// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;


@end
