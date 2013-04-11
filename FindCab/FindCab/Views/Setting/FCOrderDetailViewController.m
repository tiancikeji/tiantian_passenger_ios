//
//  FCOrderDetailViewController.m
//  FindCab
//
//  Created by paopao on 13-4-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCOrderDetailViewController.h"

@interface FCOrderDetailViewController ()

@end

@implementation FCOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
        [self createNaviBar];
        [self setStrNaviTitle:@"订单详情"];
        [self createNaviBtnLeft:[UIImage imageNamed:@"cancel.png"] title:@"返回"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
