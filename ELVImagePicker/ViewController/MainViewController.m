//
//  MainViewController.m
//  ELVImagePicker
//
//  Created by Elvin on 2017/11/28.
//  Copyright © 2017年 Elvin. All rights reserved.
//

#import "MainViewController.h"
#import "ELVAlbumPickerViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imagerPicker:(id)sender {
    ELVAlbumPickerViewController *imagePickerVC = [[ELVAlbumPickerViewController alloc] init];
    UINavigationController *imagePickerNC = [[UINavigationController alloc] initWithRootViewController:imagePickerVC];
    [self presentViewController:imagePickerNC animated:YES completion:^{
        
    }];
}

@end
