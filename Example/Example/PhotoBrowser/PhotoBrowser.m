//
//  PhotoBrowser.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "PhotoBrowser.h"
#import "PhotoView.h"
#import "PhotoBrowserAction.h"
#import "PhotoToolbar.h"
#import "Photo.h"
#import "MBProgressHUD+Add.h"
#import "SDWebImageManager+Down.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Padding 10
#define PhotoViewTagOffset 1000
#define PhotoViewIndex(photoView) ([photoView tag] - PhotoViewTagOffset)
@interface PhotoBrowser () <PhotoViewDelegate>
/// 滚动的view
@property (nonatomic, weak) UIScrollView *photoScrollView;
/// 可见
@property (nonatomic, strong) NSMutableSet *visiblePhotoViews;
/// 重复
@property (nonatomic, strong) NSMutableSet *reusablePhotoViews;
///  工具条
@property (nonatomic, weak) PhotoToolbar *toolbar;
///   一开始的状态栏
@property (nonatomic, assign,getter=isStatusBarHiddenInited) BOOL statusBarHiddenInited;
@end

@implementation PhotoBrowser

#pragma mark - Lifecycle
- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        // 1.创建UIScrollView
    [self setupScrollView];
    if (_photos.count>1&&!self.isDispaly) {
        PhotoBrowserTopType type=[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserTopType;
        switch (type) {
            case PhotoBrowserTopSettingType:
                [self setupCollectButton];
                break;
            case PhotoBrowserTopCustomType:
                [self setupCollectButton];
                break;
            default:
                break;
        }
    }
    

    // 2.创建工具条
    [self setupToolbar];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];

    if (_currentPhotoIndex == 0) {
        [self showphotos];
    }
}

- (void)setupCollectButton{
    UIButton *button=[UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame=CGRectMake(ScreenWidth-50, 20, 30, 30);
     PhotoBrowserTopType type=[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserTopType;
    NSString *image=[[NSString alloc]init];
    switch (type) {
        case PhotoBrowserTopSettingType:
            image=@"PhotoBrowse.bundle/setting";
            break;
        case PhotoBrowserTopCustomType:
            image=@"";
            break;
            
        default:
            break;
    }
     [button addTarget:self action:@selector(collectController) forControlEvents:(UIControlEventTouchUpInside)];
    [button setImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [self.view addSubview:button];
    
}

- (void)collectController{

    if ([self.delegate respondsToSelector:@selector(photoBrowser:Photos:)]) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self.delegate photoBrowser:self Photos:_photos];
     
    }
}



#pragma mark 创建工具条
- (void)setupToolbar
{
    CGFloat barHeight = 94;
    CGFloat barY = self.view.frame.size.height - barHeight;
   PhotoToolbar  *toolbar = [[PhotoToolbar alloc] init];
    self.toolbar=toolbar;
  
    self.toolbar.frame = CGRectMake(0, barY, self.view.frame.size.width, barHeight);
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.toolbar.photos = _photos;
    [self.view addSubview:self.toolbar];
    
    [self updateTollbarState];
}

#pragma mark 创建UIScrollView
- (void)setupScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= Padding;
    frame.size.width += (2 * Padding);
    UIScrollView  *photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.photoScrollView=photoScrollView;
	self.photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.photoScrollView.pagingEnabled = YES;
	self.photoScrollView.delegate = self;
	self.photoScrollView.showsHorizontalScrollIndicator = NO;
	self.photoScrollView.showsVerticalScrollIndicator = NO;
	self.photoScrollView.backgroundColor = [UIColor clearColor];
    self.photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
	[self.view addSubview:self.photoScrollView];
    self.photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        Photo *photo = _photos[i];
        photo.index = i;
        photo.isFirstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    
    for (int i = 0; i<_photos.count; i++) {
        Photo *photo = _photos[i];
        photo.isFirstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        self.photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * self.photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showphotos];
    }
}

#pragma mark - PhotoView代理
- (void)photoViewSingleTap:(PhotoView *)photoView
{
    [UIApplication sharedApplication].statusBarHidden =self.isStatusBarHiddenInited;
    self.view.backgroundColor = [UIColor clearColor];
    
    // 移除工具条
    [_toolbar removeFromSuperview];
}

- (void)photoViewDidEndZoom:(PhotoView *)photoView
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
   
}

- (void)photoViewImageFinishLoad:(PhotoView *)photoView
{
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}
- (void)photoView:(PhotoView *)photoView index:(NSUInteger)index{
    NSUInteger index1=[PhotoBrowserAction sharedPhotoBrowserAction].index;
    NSUInteger index2=[PhotoBrowserAction sharedPhotoBrowserAction].index1;
    NSUInteger index3=[PhotoBrowserAction sharedPhotoBrowserAction].saveImageIndex;
    BOOL isTag=[PhotoBrowserAction sharedPhotoBrowserAction].isTag;
    BOOL isIndex=[PhotoBrowserAction sharedPhotoBrowserAction].isIndex;
       if ((isTag||isIndex)&&index!=index3) {
        if (index==index1||index==index2) {
            if ([self.delegate respondsToSelector:@selector(photoBrowser:Actionindex:)]) {
                
                [photoView  performSelector:@selector(dismiss) withObject:nil afterDelay:0];
                [self.delegate photoBrowser:self Actionindex:index];
            }
        }else{
           if ([self.delegate respondsToSelector:@selector(photoBrowser:index:)]) {
            
            [self.delegate photoBrowser:self index:index];
        }
        }
        }
       else  {
           
               [self saveImage];
           

       }
}

- (void) saveImage {
    NSString *collectionImageName=[PhotoBrowserAction sharedPhotoBrowserAction].productName;
    
    if (!collectionImageName) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Photo *photo = _photos[_currentPhotoIndex];
            UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        });
    }else{
        
        [self saveCollectImage];
    }
}
- (void)saveCollectImage{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        if (status != PHAuthorizationStatusAuthorized)
        {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            
            // 保存相片到相机胶卷
            __block PHObjectPlaceholder *createdAsset = nil;
            Photo *photo=_photos[_currentPhotoIndex];
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdAsset = [PHAssetCreationRequest creationRequestForAssetFromImage:photo.image].placeholderForCreatedAsset;
            } error:&error];
            
            if (error) {
                [MBProgressHUD showError :@"保存失败" toView:nil];
                return;
            }
            
            // 拿到自定义的相册对象
            PHAssetCollection *collection = [self collection];
            if (collection == nil) return;
            
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [[PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection] insertAssets:@[createdAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            
            if (error) {
                [MBProgressHUD showError:@"保存失败" toView:nil];
                
            } else {
                [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
                photo.isSave=YES;
                [self updateTollbarState];
         
            }
        });
    }];
    
}
- (PHAssetCollection *)collection
{    NSString *CollectionImageName=[PhotoBrowserAction sharedPhotoBrowserAction].productName;
    // 先从已存在相册中找到自定义相册对象
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:CollectionImageName]) {
            return collection;
        }
    }
    // 新建自定义相册
    __block NSString *collectionId = nil;
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:CollectionImageName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    if (error) {
        [MBProgressHUD showSuccess:@"保存失败" toView:nil];
        return nil;
    }
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].lastObject;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showError:@"保存失败" toView:nil];
        
    } else {
        Photo *photo = _photos[_currentPhotoIndex];
        photo.isSave = YES;
        [self updateTollbarState];
    
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}

#pragma mark 显示照片
- (void)showphotos
{
    // 只有一张图片
    if (_photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = self.photoScrollView.bounds;
	NSInteger firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+Padding*2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-Padding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (PhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = PhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    PhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[PhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = self.photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * Padding);
    photoViewFrame.origin.x = (bounds.size.width * index) + Padding;
    photoView.tag = PhotoViewTagOffset + index;
    
    Photo *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [self.photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSUInteger)index
{
    if (index > 0) {
        Photo *photo = _photos[index - 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
    
    if (index < _photos.count - 1) {
        Photo *photo = _photos[index + 1];
        [SDWebImageManager downloadWithURL:photo.url];
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (PhotoView *photoView in _visiblePhotoViews) {
		if (PhotoViewIndex(photoView) == index) {
           return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (PhotoView *)dequeueReusablePhotoView
{
    PhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark 更新toolbar状态
- (void)updateTollbarState
{
    _currentPhotoIndex = self.photoScrollView.contentOffset.x / self.photoScrollView.frame.size.width;
    _toolbar.currentPhotoIndex = _currentPhotoIndex;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showphotos];
    [self updateTollbarState];
}
-  (void)photoToolbar:(PhotoToolbar *)photoToolbar button:(UIButton *)button{
  
}
@end