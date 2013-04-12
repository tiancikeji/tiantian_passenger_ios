//
//  FCLoginCheckViewController.m
//  FindCab
//
//  Created by paopao on 13-3-25.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCLoginCheckViewController.h"

@interface FCLoginCheckViewController ()
{
    int second;
}
- (void)loadContent;//加载内容
- (BOOL)checkInData;//验证输入是否正确
- (void)getVertiCode:(UIButton *)sender;//获取验证码
- (void)submitButton:(UIButton *)sender;//提交验证
- (void)countDown:(NSTimer *)timer;//倒计时
- (void)intoMap:(NSNumber *)uid;//进入地图界面
- (BOOL)isConnected;//判断网络是否连接

@end

@implementation FCLoginCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self  createNaviBar];
    [self setStrNaviTitle:@"手机验证"];
    self.navigationController.navigationBarHidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadContent];

	// Do any additional setup after loading the view.
}

- (BOOL)isConnected
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![app isConnectionAvailable]  ) {
        [FCHUD showErrorWithStatus:@"请你连接网络"];
        return NO;
    }
    return YES;
}

/* 加载界面 */
- (void)loadContent{

    UIImageView *imgInputBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_bg.png"]];
    imgInputBg.userInteractionEnabled = YES;
    CGRect frame = imgInputBg.frame;
    frame.origin = CGPointMake(25,80);
    imgInputBg.frame = frame;
    [self.view addSubview:imgInputBg];
    
    _phoneNumberField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imgInputBg.frame.size.width-50, imgInputBg.frame.size.height)];
    _phoneNumberField.delegate = self;
    _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumberField.font = [UIFont systemFontOfSize:13];
    _phoneNumberField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberField.placeholder = @"请输入手机号码";
    _phoneNumberField.text = [self myNumber];
    [imgInputBg addSubview:_phoneNumberField];
    
    
    UIImageView *verCode = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tf_vertiCode"]];
    verCode.userInteractionEnabled = YES;
    //    frame.origin = CGPointMake(25,90);
    verCode.frame = CGRectMake(25, 135,verCode.frame.size.width ,verCode.frame.size.height);
    [self.view addSubview:verCode];
    
    _vertifiCodeField = [[UITextField alloc] initWithFrame:CGRectMake(35, 135,verCode.frame.size.width - 50, verCode.frame.size.height)];
    _vertifiCodeField.delegate = self;
    _vertifiCodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _vertifiCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _vertifiCodeField.font = [UIFont systemFontOfSize:13];
    _vertifiCodeField.keyboardType = UIKeyboardTypeNumberPad;
    _vertifiCodeField.placeholder = @"请输入验证码";
    [self.view addSubview:_vertifiCodeField];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_getCode"];
    UIImage *imgBtnA = [UIImage imageNamed:@"btn_getCodeA"];
    _getVertifiCodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_getVertifiCodeButton setFrame:CGRectMake(180, _vertifiCodeField.frame.origin.y, imgBtn.size.width, imgBtn.size.height)];
    [_getVertifiCodeButton setBackgroundImage:imgBtn forState:UIControlStateNormal];\
    [_getVertifiCodeButton setBackgroundImage:imgBtnA forState:UIControlStateSelected];
    [_getVertifiCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVertifiCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_getVertifiCodeButton addTarget:self action:@selector(getVertiCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVertifiCodeButton];
    
    UIImage *sub = [UIImage imageNamed:@"btn_submit"];
    UIImage *subA = [UIImage imageNamed:@"btn_submitA"];
    _sumbitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sumbitButton setFrame:CGRectMake(25, 190, sub.size.width, sub.size.height)];
    [_sumbitButton setBackgroundImage:sub forState:UIControlStateNormal];
    [_sumbitButton setBackgroundImage:subA forState:UIControlStateHighlighted];
    [_sumbitButton setTitle:@"提交验证" forState:UIControlStateNormal];
    [_sumbitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sumbitButton addTarget:self action:@selector(submitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sumbitButton];
}

/*
 获取手机号 可能是苹果私有 不知是否可以获取 可能会被拒 要查清楚
 */
- (NSString *)myNumber{
    return CTSettingCopyMyPhoneNumber();
}

/* 
 提交验证码 判断验证码和手机号码是否匹配
 匹配：进入打车界面
 否：继续验证
 */
- (void)submitButton:(UIButton *)sender
{
    if (![self isConnected]) {
        return;
    }
    phoneNumber = self.phoneNumberField.text;
    verfifyCode = self.vertifiCodeField.text;
    
    if (!self.vertifiCodeField.text || self.vertifiCodeField.text.length==0) {
        [FCHUD showErrorWithStatus:@"验证码不能为空"];
        [self.vertifiCodeField becomeFirstResponder];
        return;
    }
//    [self intoMap:[NSNumber numberWithInt:2] haveLogin:YES];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *deviceUID = appDelegate.strDeviceToken;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"haha",@"name",phoneNumber,@"mobile",verfifyCode,@"password",deviceUID,@"iosDevice",nil];
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = SUBMITCODE;
    response.type = POST;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:dict forKey:@"passenger"]];
}

- (void)intoMap:(NSNumber *)userID
{
    FCHomePageViewController *homePage = [[FCHomePageViewController alloc] init];
    if (!_passenger) {
        _passenger = [[Passenger alloc] init];
    }
    _passenger.uid = userID;
    homePage.passenger = _passenger;
    [self.navigationController pushViewController:homePage animated:YES];
}

/*
 
  获取验证码
  手机号传server  server发送验证码到号码 
  返回验证码及手机对应信息
  
 */
- (void)getVertiCode:(UIButton *)sender
{
    if (![self isConnected]) {
        return;
    }
    if (![self checkInData]) {
        return;
    }
    sender.selected = !sender.selected;
    sender.enabled = NO;
    second = 60;
    [self.getVertifiCodeButton setTitle:@"60秒后重获" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.phoneNumberField.text,@"mobile",nil];
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = GETCODE;
    response.type = GET;
    [response startQueryAndParse:dict];
}

/* 获取验证码成功 登陆成功 */
- (void)queryFinished:(NSString *)strData
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *parseError = nil;
    NSMutableDictionary *dict = (NSMutableDictionary *)[jsonParser objectWithString:strData error:&parseError];
    if ([dict objectForKey:@"passenger"]) {
        if (!_passenger) {
            _passenger = [[Passenger alloc] init];
        }
        _passenger.uid = [[dict valueForKey:@"passenger"] valueForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_passenger.uid forKey:@"uid"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:_phoneNumberField.text forKey:@"phoneNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self intoMap:_passenger.uid];
        [FCHUD showSuccessWithStatus:@"登陆成功"];
    }
}

- (void)queryError:(NSError *)errorConnect
{
    [FCHUD showErrorWithStatus:@"登陆失败，请核对手机号和验证码"];
}

/*
 
 倒计时
 点击获取验证码 60秒倒计时开始 此时该按钮不可用 到0可用
 
 */
- (void)countDown:(NSTimer *)timer
{
    --second;
    [self.getVertifiCodeButton setTitle:[NSString stringWithFormat:@"%d后重获",second] forState:UIControlStateNormal];
    if (second == 0) {
        [self.getVertifiCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.getVertifiCodeButton setEnabled:YES];
        [timer invalidate];
    }
}

//输入格式是否正确
- (BOOL)checkInData
{
    if (![FCCheckData isValidatePhoneNumber:self.phoneNumberField.text]) {
        //        [FCHUD showErrorWithStatus:@"请输入正确的手机号码" duration:2.5];
        [FCHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [self.phoneNumberField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
