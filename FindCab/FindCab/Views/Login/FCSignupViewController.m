//
//  FCSignupViewController.m
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCSignupViewController.h"
#import "FCHomePageViewController.h"
#import "GBUtility.h"
#import "FCCheckData.h"

@interface FCSignupViewController ()

@end

@implementation FCSignupViewController
@synthesize homePageCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNaviBar];
    self.strNaviTitle = @"注册";
    [self createNaviBtnLeft:[UIImage imageNamed:@"cancel"] title:nil];
    [btnNaviLeft addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadContent];
	// Do any additional setup after loading the view.
}

- (void)loadContent{
    for (int i = 0; i < 3; i++) {
        UIImageView *imgInputBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_bg"]];
        imgInputBg.userInteractionEnabled = YES;
        CGRect frame = imgInputBg.frame;
        frame.origin = CGPointMake(25, imgvNavBar.frame.size.height+25+50*i);
        imgInputBg.frame = frame;
        [self.view addSubview:imgInputBg];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, imgInputBg.frame.size.width-20, imgInputBg.frame.size.height)];
        textField.delegate = self;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.font = [UIFont systemFontOfSize:14];
        
        switch (i) {
            case 0:
            {
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.placeholder = @"手机号码";
                textUserName = textField;
            }
                break;
            case 1:
            {
                textField.secureTextEntry = YES;
                textField.placeholder = @"输入密码";
                textPassword = textField;
            }
                break;
            case 2:
            {
                textField.secureTextEntry = YES;
                textField.placeholder = @"确认密码";
                textConfirm = textField;
            }
                break;
                
            default:
                break;
        }

        [imgInputBg addSubview:textField];
    }

    
//    if (!textUserName) {
//        textUserName = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 35)];
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
//        textPassword = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, 280, 35)];
//        textPassword.delegate = self;
//        textPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        textPassword.secureTextEntry = YES;
//        //textPassword.keyboardType = UIKeyboardTypeNumberPad;
//        textPassword.placeholder = @"密码";
//        textPassword.borderStyle = UITextBorderStyleLine;
//        textPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textPassword.font = [UIFont systemFontOfSize:14];
//    }
//    [self.view addSubview:textPassword];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_style1"];
    UIButton *btnRegist = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnRegist setFrame:CGRectMake((self.view.frame.size.width-imgBtn.size.width)/2.0, 220, imgBtn.size.width, imgBtn.size.height)];
    [btnRegist setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [btnRegist setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegist addTarget:self action:@selector(clickSignupBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegist];
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

- (void)clickSignupBtn{
    if (![self checkInputData]) {
        return;
    }
    [FCHUD showWithStatus:@"正在注册"];
    //NSString *strToken = [[KTData sharedObject] getToken];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Leon2",@"name",textUserName.text,@"mobile", [GBUtility encode:textPassword.text],@"password",nil];
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = @"api/passengers/signup";
    response.type = POST;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:dict forKey:@"passenger"]];
    //[response startQueryAndParse:(NSMutableDictionary *)dict];
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
    
    
    [FCHUD showSuccessWithStatus:@"注册成功"];
    
    [self performSelector:@selector(showHomePage) withObject:nil afterDelay:2.0];
}

- (void)showHomePage{
    [self dismissModalViewControllerAnimated:YES];
//    FCHomePageViewController *controller = [[FCHomePageViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
