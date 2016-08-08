//
//  PhotoProgressView.h
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface PhotoProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic,assign) float progress;

@end
