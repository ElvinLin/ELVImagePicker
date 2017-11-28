//
//  ELVImagerPickerViewController.m
//  ELVImagePicker
//
//  Created by Elvin on 2017/11/28.
//  Copyright © 2017年 Elvin. All rights reserved.
//

#import "ELVImagerPickerViewController.h"
#import <Photos/Photos.h>

static NSString *CELLID = @"ELVImagerPickerViewControllerCellID";

@interface ELVImagerPickerViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *smartAlbumArray;
@property (nonatomic, strong) NSMutableArray *userAlbumArray;
@property (nonatomic, assign) NSInteger *smartAlbumCount;
@property (nonatomic, assign) NSInteger *userAlbumCount;

@property (nonatomic, strong) NSMutableArray *smartAlbumImageArray;
@property (nonatomic, strong) NSMutableArray *userAlbumImageArray;

@end

@implementation ELVImagerPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    self.smartAlbumArray = [[NSMutableArray alloc] init];
    self.userAlbumArray = [[NSMutableArray alloc] init];
    self.smartAlbumImageArray = [[NSMutableArray alloc] init];
    self.userAlbumImageArray = [[NSMutableArray alloc] init];
    
    self.smartAlbumCount = 0;
    self.userAlbumCount = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        [self loadData];
    } else if (photoAuthorStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadData];
            }else {
                [self showPhotoDeniedAlert];
            }
        }];
    } else {
        [self showPhotoDeniedAlert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close {
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)showPhotoDeniedAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Need Photo Permission"
                                                                   message:@"Using this app need photo permission, do you want to turn on it?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          NSURL *settingsUrl = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
                                                          [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:^(BOOL success) {
                                                              
                                                          }];
                                                      }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * action) {
                                                     }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)loadData {
    PHFetchResult *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in smartAlbum){
        if ([collection.localizedTitle isEqualToString:NSLocalizedString(@"Camera Roll", @"")] ||
            [collection.localizedTitle isEqualToString:NSLocalizedString(@"Favorites", @"")] ||
            [collection.localizedTitle isEqualToString:NSLocalizedString(@"Screenshots", @"")] ||
            [collection.localizedTitle isEqualToString:NSLocalizedString(@"Selfies", @"")]) {
            [self.smartAlbumArray addObject:collection];
            self.smartAlbumCount++;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            //fetch all image assets from collection list
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            PHAsset *asset = [assetsFetchResult lastObject];
            CGSize size = CGSizeMake(100, 100);
            [manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [self.smartAlbumImageArray addObject:result];
                self.smartAlbumCount--;
                if (self.smartAlbumCount == 0) {
                    [self.tableView reloadData];
                }
            }];
        }
        //NSLog(@"Album = %@", collection.localizedTitle);
    }
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    for (PHAssetCollection *collection in userAlbums){
        [self.userAlbumArray addObject:collection];
        self.userAlbumCount++;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        //fetch all image assets from collection list
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        PHAsset *asset = [assetsFetchResult firstObject];
        CGSize size = CGSizeMake(100, 100);
        [manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self.userAlbumImageArray addObject:result];
            self.userAlbumCount--;
            if (self.userAlbumCount == 0) {
                [self.tableView reloadData];
            }
        }];
        //NSLog(@"Album = %@", collection.localizedTitle);
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section == 0) {
        count = self.smartAlbumArray.count;
    } else if (section == 1) {
        count = self.userAlbumArray.count;
    }
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *collection;
    UIImageView *imageView = nil;
    NSString *title = @"";
    if (indexPath.section == 0) {
        collection = self.smartAlbumArray[indexPath.row];
        imageView = [self.smartAlbumImageArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        collection = self.userAlbumArray[indexPath.row];
        imageView = [self.userAlbumImageArray objectAtIndex:indexPath.row];
    }
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    NSInteger count = assetsFetchResult.count;
    //NSLog(@"Album:%@ count:%lu", collection.localizedTitle, count);
    title = [NSString stringWithFormat:@"%@(%lu)", collection.localizedTitle, count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    [cell.textLabel setText:title];
    if (imageView != nil) {
        [cell.imageView setImage:imageView];
    }
    
    return cell;
}

@end
