//
//  FCLoginViewController.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "Passenger.h"
@class FCHomePageViewController;

@interface FCLoginViewController : FCBaseViewController<UITextFieldDelegate>{
    UITextField *textUserName,*textPassword;
    FCHomePageViewController *homePageCtrl;
    Passenger *passenger;
}
@property (nonatomic, strong) FCHomePageViewController *homePageCtrl;

@end
