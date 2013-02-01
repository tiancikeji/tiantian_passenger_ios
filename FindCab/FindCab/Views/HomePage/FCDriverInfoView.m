//
//  FCDriverInfoView.m
//  FindCab
//
//  Created by leon on 13-1-18.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCDriverInfoView.h"
#import "FCHomePageViewController.h"

@implementation FCDriverInfoView
@synthesize driverInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadContent{
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:self.bounds];
    imgBg.image = [UIImage imageNamed:@"driver_info_panel"];
    [self addSubview:imgBg];
    
    UIImage *imgNormal = [UIImage imageNamed:@"phone_normal"];
    UIImage *imgHiglight = [UIImage imageNamed:@"phone_highlight"];
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCall setImage:imgNormal forState:UIControlStateNormal];
    [btnCall setImage:imgHiglight forState:UIControlStateHighlighted];
    [btnCall setFrame:CGRectMake(220, 11, imgNormal.size.width, imgNormal.size.height)];
    [btnCall addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCall];
    
    for (int i = 0; i < 2; i++) {
        UILabel *labelTemp1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 14+27*i, 170, 15)];
        labelTemp1.backgroundColor = [UIColor clearColor];
        labelTemp1.font = [UIFont systemFontOfSize:14];
        labelTemp1.textColor = [UIColor whiteColor];
        
        UILabel *labelTemp2 = [[UILabel alloc] initWithFrame:CGRectMake(40+100*i, 84, 40, 15)];
        labelTemp2.backgroundColor = [UIColor clearColor];
        labelTemp2.font = [UIFont boldSystemFontOfSize:15];
        labelTemp2.textAlignment = UITextAlignmentCenter;
        labelTemp2.textColor = [UIColor whiteColor];
        
        UILabel *labelTemp3 = [[UILabel alloc] initWithFrame:CGRectMake(80+100*i, 86, 80, 13)];
        labelTemp3.backgroundColor = [UIColor clearColor];
        labelTemp3.font = [UIFont systemFontOfSize:13];
        labelTemp3.textColor = [UIColor whiteColor];
        
        if (i==0) {
            labelUserName = labelTemp1;
            labelMiles = labelTemp2;
            labelTemp3.text = @"公里";
        }
        else {
            labelDesription = labelTemp1;
            labelTime = labelTemp2;
            labelTemp3.text = @"分钟";
        }
        [self addSubview:labelTemp1];
        [self addSubview:labelTemp2];
        [self addSubview:labelTemp3];
    }
}

- (void)clickCallBtn{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"]) {
        UIViewController *controller = [self viewController:self];
        if ([controller isKindOfClass:[FCHomePageViewController class]]) {
            [controller performSelector:@selector(showLoginPage)];
        }
        return;
    }
    
    
    NSString *number = [NSString stringWithFormat:@"telprompt://%@",driverInfo?driverInfo.mobile:@"88888888"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}

- (UIViewController*)viewController:(UIView *)vi {
    for (UIView* next = [vi superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)updateUserInfo{
    if (driverInfo) {
        labelUserName.text = driverInfo.name;
        labelDesription.text = [NSString stringWithFormat:@"%@,%@",driverInfo.car_type,driverInfo.car_license];//@"南汽,京C44438";
        labelMiles.text = @"03";
        labelTime.text = @"45";
    }
    else {
        labelUserName.text = @"张师傅已应答";
        labelDesription.text = @"南汽,京C44438";
        labelMiles.text = @"03";
        labelTime.text = @"45";
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
