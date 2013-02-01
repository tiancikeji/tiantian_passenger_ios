//
//  FCBaseViewController.m
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"

@interface FCBaseViewController ()

@end

@implementation FCBaseViewController
@synthesize strNaviTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)createNaviBar{
    imgvNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgvNavBar.userInteractionEnabled = YES;
    imgvNavBar.image = [UIImage imageNamed:@"navi_bar"];//[[UIImage imageNamed:@"title_bar"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.view addSubview:imgvNavBar];
    
    labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, imgvNavBar.frame.size.height)];
    labelTitle.textAlignment = UITextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:18.0];
    //labelTitle.textColor = [UIColor whiteColor];
    //lblTitle.text = @"猫小咪";
    labelTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelTitle];
}

- (void)setStrNaviTitle:(NSString *)title{
    labelTitle.text = title;
}

#define BTN_PADDING_LEFT 15.0
#define BTN_PADDING_RIGHT 15.0

- (void)createNaviBtnLeft:(UIImage *)img title:(NSString *)strTitle{
    if (!btnNaviLeft) {
        CGSize sz = img.size;
        btnNaviLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNaviLeft.frame = CGRectMake(BTN_PADDING_LEFT, (imgvNavBar.frame.size.height-sz.height)/2.0, sz.width, sz.height);
        [btnNaviLeft setBackgroundImage:img forState:UIControlStateNormal];
        btnNaviLeft.titleLabel.font = [UIFont systemFontOfSize:14];
        if (strTitle) {
            [btnNaviLeft setTitle:strTitle forState:UIControlStateNormal];
            [btnNaviLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    [imgvNavBar addSubview:btnNaviLeft];
   // [btnNaviLeft setImage:img forState:UIControlStateNormal];
}

- (void)createNaviBtnRight:(UIImage *)img title:(NSString *)strTitle{
    if (!btnNaviRight) {
        CGSize sz = img.size;
        btnNaviRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNaviRight.frame = CGRectMake(imgvNavBar.frame.size.width-BTN_PADDING_RIGHT-sz.width, (imgvNavBar.frame.size.height-sz.height)/2.0, sz.width, sz.height);
        [btnNaviRight setBackgroundImage:img forState:UIControlStateNormal];
        btnNaviRight.titleLabel.font = [UIFont systemFontOfSize:14];
        if (strTitle) {
            [btnNaviRight setTitle:strTitle forState:UIControlStateNormal];
            [btnNaviRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    [imgvNavBar addSubview:btnNaviRight];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
