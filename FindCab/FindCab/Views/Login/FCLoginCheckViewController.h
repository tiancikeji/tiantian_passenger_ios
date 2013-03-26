//
//  FCLoginCheckViewController.h
//  FindCab
//
//  验证用户页面
//
//  Created by paopao on 13-3-25.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCBaseViewController.h"
#import "FCHomePageViewController.h"
#import "AppDelegate.h"
#import "FCCheckData.h"
#import "Configurations.h"
#import "GBUtility.h"
#import "Passenger.h"

@class FCHomePageViewController;

@interface FCLoginCheckViewController : FCBaseViewController<UITextFieldDelegate,ServiceResponseDelegate>
{
    NSString *phoneNumber;
    NSString *verfifyCode;
}

@property(nonatomic,strong) Passenger *passenger;
/* 输入手机号 */
@property(nonatomic,strong) UITextField *phoneNumberField;

/* 输入验证码 */
@property(nonatomic,strong) UITextField *vertifiCodeField;

/* 获取验证码 */
@property(nonatomic,strong) UIButton *getVertifiCodeButton;

/* 提交验证 */
@property(nonatomic,strong) UIButton *sumbitButton;

@end
