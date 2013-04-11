//
//  MyOrderCell.h
//  FindCab
//
//  Created by paopao on 13-4-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderCell : UITableViewCell


@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *startIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *endIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *dateIcon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *startLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *endLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;

@end
