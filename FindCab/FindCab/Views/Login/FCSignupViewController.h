//
//  FCSignupViewController.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "FCHomePageViewController.h"

@interface FCSignupViewController : FCBaseViewController<UITextFieldDelegate>{
    UITextField *textUserName,*textPassword,*textConfirm;
    Passenger *passenger;
}

@property (nonatomic, strong) FCHomePageViewController *homePageCtrl;

@end
