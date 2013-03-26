//
//  ViewController.m
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "ViewController.h"
#import "FCLoginCheckViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    controller = [[FCLoginCheckViewController alloc] init];
    //controller = [[FCLoginViewController alloc] init];
    naviCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
    naviCtrl.navigationBarHidden = YES;
    naviCtrl.view.frame = self.view.bounds;
    [self.view addSubview:naviCtrl.view];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
