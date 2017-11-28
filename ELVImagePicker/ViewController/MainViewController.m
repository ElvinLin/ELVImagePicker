//
//  MainViewController.m
//  ELVImagePicker
//
//  Created by Elvin on 2017/11/28.
//  Copyright © 2017年 Elvin. All rights reserved.
//

#import "MainViewController.h"
#import "ELVImagerPickerViewController.h"

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
    ELVImagerPickerViewController *imagePickerVC = [[ELVImagerPickerViewController alloc] init];
    UINavigationController *imagePickerNC = [[UINavigationController alloc] initWithRootViewController:imagePickerVC];
    [self presentViewController:imagePickerNC animated:YES completion:^{
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
