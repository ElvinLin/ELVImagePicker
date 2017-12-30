//
//  ELVImagePickerViewController.m
//  ELVImagePicker
//
//  Created by LinElvin on 2017/12/1.
//  Copyright © 2017年 Elvin. All rights reserved.
//

#import "ELVImagePickerViewController.h"

@interface ELVImagePickerViewController ()
@property (nonatomic, strong) NSMutableArray *albumImageArray;
@property (nonatomic, assign) NSInteger imageCount;

@end

@implementation ELVImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.collection.localizedTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"down" style:UIBarButtonItemStylePlain target:self action:@selector(down)];
    
    self.albumImageArray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)down {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)loadData {
    PHImageManager *manager = [PHImageManager defaultManager];
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:self.collection options:nil];
    self.imageCount = assetsFetchResult.count;
    NSLog(@"Total Count = %zd", self.imageCount);
    CGSize size = CGSizeMake(100, 100);
    //for (PHAsset *asset in assetsFetchResult) {
    for (int i = 0; i < 1 ; i++) {
        PHAsset *asset = [assetsFetchResult objectAtIndex:i];
        [manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result == nil) {
                [self.albumImageArray addObject:[[UIImage alloc] init]];
            } else {
                [self.albumImageArray addObject:result];
            }
        }];
    }
}

@end
