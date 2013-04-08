//
//  FCSettingsViewController.m
//  FindCab
//
//  Created by paopao on 13-4-8.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCSettingsViewController.h"

@interface FCSettingsViewController ()

@end

@implementation FCSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self createNaviBar];
        [self setTitle:@"设置"];
        [self createNaviBtnLeft:[UIImage imageNamed:@"cancel.png"] title:@"返回"];    }
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
