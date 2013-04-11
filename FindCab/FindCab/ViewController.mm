//
//  ViewController.m
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "ViewController.h"
#import "FCLoginCheckViewController.h"
#import "Passenger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"]) {
        FCHomePageViewController *homePage = [[FCHomePageViewController alloc] init];
        naviCtrl = [[UINavigationController alloc] initWithRootViewController:homePage];
        naviCtrl.navigationBarHidden = YES;
        naviCtrl.view.frame = self.view.bounds;
        Passenger *_passenger = [[Passenger alloc] init];
        _passenger.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        homePage.passenger = _passenger;
        homePage.view.frame = self.view.frame;
        [self.view addSubview:naviCtrl.view];
        return;
    }
    
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
