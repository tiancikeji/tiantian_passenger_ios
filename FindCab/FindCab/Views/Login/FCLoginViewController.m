//
//  FCLoginViewController.m
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCLoginViewController.h"
#import "FCSignupViewController.h"
#import "FCHomePageViewController.h"
#import "GBUtility.h"
#import "FCCheckData.h"

@interface FCLoginViewController ()

@end

@implementation FCLoginViewController
@synthesize homePageCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [super viewWillAppear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [super viewWillDisappear:animated];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNaviBar];
    self.strNaviTitle = @"登录";
    
    //[self createNaviBtnRight:[UIImage imageNamed:@"cancel"] title:nil];
    [self createNaviBtnRight:[UIImage imageNamed:@"navibar_btn"] title:@"注册"];
    [btnNaviRight addTarget:self action:@selector(goSignupPage) forControlEvents:UIControlEventTouchUpInside];
    [self createNaviBtnLeft:[UIImage imageNamed:@"navibar_btn"] title:@"返回"];
    [btnNaviLeft addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self loadContent];
	// Do any additional setup after loading the view.
}

- (void)goBack{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadContent{
    for (int i = 0; i < 2; i++) {
        UIImageView *imgInputBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_bg"]];
        imgInputBg.userInteractionEnabled = YES;
        CGRect frame = imgInputBg.frame;
        frame.origin = CGPointMake(25, imgvNavBar.frame.size.height+25+50*i);
        imgInputBg.frame = frame;
        [self.view addSubview:imgInputBg];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imgInputBg.frame.size.width-50, imgInputBg.frame.size.height)];
        textField.delegate = self;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont systemFontOfSize:14];
        
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.placeholder = @"手机号码";
            textField.text = @"18611907350";
            textUserName = textField;
        }
        else {
            textField.secureTextEntry = YES;
            textField.placeholder = @"密码";
            textField.text = @"q";
            textPassword = textField;
            
            UIButton *btnForget = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *imgIcon = [UIImage imageNamed:@"forget"];
            [btnForget setImage:imgIcon forState:UIControlStateNormal];
            [btnForget setFrame:CGRectMake(imgInputBg.frame.size.width-10-imgIcon.size.width, (imgInputBg.frame.size.height-imgIcon.size.height)/2.0, imgIcon.size.width, imgIcon.size.height)];
            [btnForget addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
            [imgInputBg addSubview:btnForget];
        }
        
        [imgInputBg addSubview:textField];
    }
    
    UIImage *imgLoginNormal = [UIImage imageNamed:@"login_normal"];
    UIImage *imgLoginHighlight = [UIImage imageNamed:@"login_highlight"];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 0;
    [btn setFrame:CGRectMake((self.view.frame.size.width-imgLoginNormal.size.width)/2.0, 180, imgLoginNormal.size.width, imgLoginNormal.size.height)];
    [btn setImage:imgLoginNormal forState:UIControlStateNormal];
    [btn setImage:imgLoginHighlight forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    if (!textUserName) {
//        textUserName = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, 280, 35)];
//        textUserName.delegate = self;
//        textUserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        textUserName.keyboardType = UIKeyboardTypeNumberPad;
//        textUserName.placeholder = @"手机号码";
//        textUserName.borderStyle = UITextBorderStyleLine;
//        textUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textUserName.font = [UIFont systemFontOfSize:14];
//    }
//    [self.view addSubview:textUserName];
//    
//    if (!textPassword) {
//        textPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 280, 35)];
//        textPassword.delegate = self;
//        textPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        textPassword.secureTextEntry = YES;
//        textPassword.placeholder = @"密码";
//        textPassword.borderStyle = UITextBorderStyleLine;
//        textPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textPassword.font = [UIFont systemFontOfSize:14];
//    }
//    [self.view addSubview:textPassword];
    
//    for (int i = 0; i < 2; i++) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn.tag = i;
//        [btn setFrame:CGRectMake(30+110*i, 180, 80, 30)];
//        [btn setTitle:i==0?@"登录":@"注册" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//    }
    
//    UIButton *btnForget = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnForget setFrame:CGRectMake(200, 220, 120, 20)];
//    [btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
//    [btnForget addTarget:self action:@selector(clickForgetBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnForget];
}

- (void)clickBtn:(id)sender{
    switch (((UIButton *)sender).tag) {
        case 0:
        {
            //FCHUD *kk = [[FCHUD alloc] init];
            //[FCHUD showWithStatus:@"正在登录"];
            //[self performSelector:@selector(goHomePage) withObject:nil afterDelay:2.0];
            //[self goHomePage];
            [self userLogin];
        }
            break;
        case 1:
        {
            [self goSignupPage];
        }
            break;
            
        default:
            break;
    }
}

- (void)userLogin{
    if (![self checkInputData]) {
        return;
    }
    [FCHUD showWithStatus:@"正在登录"];
    //NSString *strToken = [[KTData sharedObject] getToken];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:textUserName.text,@"mobile", [GBUtility encode:textPassword.text],@"password",nil];
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = @"api/passengers/signin";
    response.type = POST;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:dict forKey:@"passenger"]];
}

- (BOOL)checkInputData{
    if (![FCCheckData isValidatePhoneNumber:textUserName.text]) {
        [FCHUD showErrorWithStatus:@"请输入正确的手机号码"];
        [textUserName becomeFirstResponder];
        return NO;
    }
    if (!textPassword.text || textPassword.text.length==0) {
        [FCHUD showErrorWithStatus:@"请输入密码"];
        [textPassword becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)queryFinished:(NSString *)strData{
    [FCHUD dismiss];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *parseError = nil;
    NSMutableDictionary *dict = (NSMutableDictionary *)[jsonParser objectWithString:strData error:&parseError];
    NSLog(@"%@",dict);
    
    if (!passenger) {
        passenger = [[Passenger alloc] init];
    }
    passenger.uid = [[dict valueForKey:@"passenger"] valueForKey:@"id"];
    
    homePageCtrl.passenger = passenger;
    
    [[NSUserDefaults standardUserDefaults] setObject:passenger.uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveLogin"];
    [self dismissModalViewControllerAnimated:YES];
    //[self goHomePage];
    //[FCHUD showSuccessWithStatus:@"登录成功" duration:2.5];
    
    //[self performSelector:@selector(showHomePage) withObject:nil afterDelay:2.0];
}

//- (void)showHomePage{
//    FCHomePageViewController *controller = [[FCHomePageViewController alloc] init];
//    
//    [self.navigationController pushViewController:controller animated:YES];
//}

- (void)clickForgetBtn{
}

- (void)goSignupPage{
    FCSignupViewController *controller = [[FCSignupViewController alloc] init];
    controller.homePageCtrl = homePageCtrl;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goHomePage{
    [FCHUD dismiss];
    FCHomePageViewController *controller = [[FCHomePageViewController alloc] init];
    controller.passenger = passenger;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
