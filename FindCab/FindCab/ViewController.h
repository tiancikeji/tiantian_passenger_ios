//
//  ViewController.h
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCHomePageViewController.h"
#import "FCLoginViewController.h"

@interface ViewController : UIViewController{
    FCHomePageViewController *controller;
    //FCLoginViewController *controller;
    UINavigationController *naviCtrl;
}

@end
