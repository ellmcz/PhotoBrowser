//
//  SDWebImageManager+Down.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "SDWebImageManager+Down.h"

@implementation SDWebImageManager (Down)
+ (void)downloadWithURL:(NSURL *)url
{
    // cmp不能为空
    [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    
    }];
}
@end
