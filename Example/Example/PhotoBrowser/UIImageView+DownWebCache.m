//
//  UIImageView+IOSWebCache.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import "UIImageView+DownWebCache.h"

@implementation UIImageView (DownWebCache)
- (void)setImageURL:(NSURL *)url placeholder:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

- (void)setImageURLStr:(NSString *)urlStr placeholder:(UIImage *)placeholder
{
    [self setImageURL:[NSURL URLWithString:urlStr] placeholder:placeholder];
}
@end
