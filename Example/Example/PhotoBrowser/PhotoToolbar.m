//
//  PhotoToolbar.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//


#import "PhotoToolbar.h"
#import "MBProgressHUD+Add.h"
#import "PhotoBrowserAction.h"
#import "Photo.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface PhotoToolbar()

@property (nonatomic, weak) UILabel *indexLabel;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIButton *saveImageBtn;
@property (nonatomic, weak) UITextView *textView;

@end

@implementation PhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    if (_photos.count > 1) {
         BOOL isType=[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserLabelType||[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserLabelNormalType;
        if (isType) {
        UILabel  *label = [[UILabel alloc] init];
        self.indexLabel=label;
        self.indexLabel.font = [UIFont boldSystemFontOfSize:20];
        self.indexLabel.frame = CGRectMake(0, 50, ScreenWidth, 44);
        self.indexLabel.backgroundColor = [UIColor clearColor];
        self.indexLabel.textColor = [UIColor whiteColor];
        self.indexLabel.textAlignment = NSTextAlignmentCenter;
        self.indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.indexLabel];
        }else{
        UIPageControl *pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 44)];
        self.pageControl=pageControl;
        self.pageControl.numberOfPages = _photos.count;
        self.pageControl.pageIndicatorTintColor =[PhotoBrowserAction sharedPhotoBrowserAction].pageOtherColor;
        self.pageControl.currentPageIndicatorTintColor =[PhotoBrowserAction sharedPhotoBrowserAction].pageCurrentColor ;
        [self addSubview:self.pageControl];
    }
    }
    // 保存图片按钮
    CGFloat btnWidth = 44;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveImageBtn=button;
    self.saveImageBtn.frame = CGRectMake( ScreenWidth-btnWidth,50, btnWidth, btnWidth);
    self.saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
    
    [_saveImageBtn setImage:[UIImage imageNamed:@"PhotoBrowse.bundle/save_highlighted.png"] forState:UIControlStateHighlighted];
    
[_saveImageBtn setImage:[UIImage imageNamed:@"PhotoBrowse.bundle/save.png"] forState:UIControlStateNormal];
    
    [self.saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.saveImageBtn];
    
    UITextView *textView = [[UITextView alloc] init];
    self.textView=textView;
    [self.textView setFrame:CGRectMake(10, 20, ScreenWidth-2*10, 50)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.editable = NO;
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.textView];
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
        self.saveImageBtn.enabled = NO;
        
        [MBProgressHUD showSuccess:@"成功保存到相册" toView:nil];
    }
}
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    // 更新页码
     BOOL isType=[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserLabelType||[PhotoBrowserAction sharedPhotoBrowserAction].photoBrowserType==PhotoBrowserLabelNormalType;
    if (isType) {
    self.indexLabel.text = [NSString stringWithFormat:@"%lu / %lu", _currentPhotoIndex + 1, (unsigned long)_photos.count];
    }else{
    self.pageControl.currentPage=_currentPhotoIndex;
    }
    Photo *photo = _photos[_currentPhotoIndex];
 
    [self.textView setText:photo.photoDescription];
   
    // 按钮
    
    BOOL isLight=(photo.image!= nil && !photo.isSave)||photo.isFirstShow;
    if (isLight) {
        [_saveImageBtn setImage:[UIImage imageNamed:@"PhotoBrowse.bundle/save.png"] forState:UIControlStateNormal];
        photo.isFirstShow=NO;
        self.saveImageBtn.enabled=YES;
    }else{
        [_saveImageBtn setImage:[UIImage imageNamed:@"PhotoBrowse.bundle/save_highlighted.png"] forState:UIControlStateHighlighted];
        self.saveImageBtn.enabled=NO;
    }
    
}
@end
