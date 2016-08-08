//
//  ViewController.m
//  Example
//
//  Created by MacBook Air on 16/8/5.
//  Copyright © 2016年 ellmcz. All rights reserved.
//

#import "ViewController.h"
#import "PhotoHeader.h"
#import "ImageCollectionController.h"
#import "UIImageView+WebCache.h"
@interface ViewController ()<PhotoBrowserDelegate>
@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation ViewController
- (NSMutableArray *)data{
    if (!_data) {
        _data=[[NSMutableArray alloc]init];
    }
    return _data;
}

- (void)viewDidLoad {
     int x=20;
    [self.data addObjectsFromArray:@[@"http://cms-bucket.nosdn.127.net/catchpic/D/D8/D873D28FBE9AE7ABC12378E83CD496BA.jpg",@"http://s1.dwstatic.com/group1/M00/1F/E4/1cddd745a61f3ae4f9d166e2269a0ede.gif",@"http://imgsrc.baidu.com/forum/pic/item/6ad333fa828ba61e8ec8506b4534970a314e59b2.jpg"]];
    for (int i=0; i<self.data.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(x, 80, 100, 100)];
        imageView.userInteractionEnabled=YES;
        [self.view addSubview:imageView];
        imageView.tag=i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageBrowser:)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.data[i]]];
        [imageView addGestureRecognizer:tap];
        x=(i+1)*120+20;
    }
    
   self.view.backgroundColor=[UIColor whiteColor];
    
  
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)imageBrowser:(UITapGestureRecognizer*)tap{
    UIImageView *tapView=(UIImageView *)tap.view;
    PhotoBrowser *photoBrowser=[[PhotoBrowser alloc]init];
    int index=0;
    NSMutableArray *arrayM=[NSMutableArray array];
    for (NSString *url in self.data) {
        Photo *photo=[[Photo alloc]init];
        photo.url=[NSURL URLWithString:url];
        photo.sourceImageView=tapView;
        photo.index=index;
        [arrayM addObject:photo];
    }
    photoBrowser.currentPhotoIndex=tapView.tag;
    photoBrowser.delegate=self;
    photoBrowser.photos=arrayM;
    [photoBrowser show];
}

-(void)photoBrowser:(PhotoBrowser *)photoBrowser Photos:(NSArray *)photos{

    ImageCollectionController * imageCollection=[[ImageCollectionController alloc]init];
    imageCollection.photos=photos;
    imageCollection.title=@"精彩剧照";
    [self.navigationController pushViewController:imageCollection animated:NO];
}







@end
