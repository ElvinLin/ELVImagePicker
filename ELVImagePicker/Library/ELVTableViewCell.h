//
//  ELVATableViewCell.h
//  ELVImagePicker
//
//  Created by LinElvin on 2017/12/1.
//  Copyright © 2017年 Elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELVTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
@property (weak, nonatomic) IBOutlet UILabel *albumName;

@end
