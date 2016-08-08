//
//  ImageCollectionController.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import "ImageCollectionController.h"
#import "Photo.h"
#import "UIImageView+WebCache.h"
#import "PhotoBrowser.h"
@interface ImageCollectionController ()

@end

@implementation ImageCollectionController
- (instancetype)init{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    if (self=[super initWithCollectionViewLayout:layout]) {
        layout.itemSize=CGSizeMake(100, 120);
        layout.sectionInset=UIEdgeInsetsMake(30, 20, 20, 30);

    }
    return self;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if (!cell) {
        cell=[[UICollectionViewCell alloc]init];
    }
    Photo *photo=self.photos[indexPath.item];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageBrowser:)];
    imageView.tag=indexPath.item;
    imageView.frame=cell.contentView.bounds;
    [cell.contentView addSubview:imageView];
    [imageView addGestureRecognizer:tap];

    [imageView sd_setImageWithURL:photo.url];
    
    return cell;
}
- (void)imageBrowser:(UITapGestureRecognizer*)tap{
    UIImageView *tapView=(UIImageView *)tap.view;
    PhotoBrowser *photoBrowser=[[PhotoBrowser alloc]init];
    int index=0;
    NSMutableArray *arrayM=[NSMutableArray array];
    for (Photo *p in _photos) {
        Photo *photo=[[Photo alloc]init];
        photo.url=p.url;
        photo.sourceImageView=tapView;
        
        photo.index=index;
        [arrayM addObject:photo];
    }
    photoBrowser.currentPhotoIndex=tapView.tag;
    photoBrowser.dispaly=YES;
    photoBrowser.photos=arrayM;
    
    
    [photoBrowser show];}
#pragma mark <UICollectionViewDelegate>



@end
