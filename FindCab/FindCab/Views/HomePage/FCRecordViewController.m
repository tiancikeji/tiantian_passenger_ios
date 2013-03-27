//
//  FCRecordViewController.m
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCRecordViewController.h"
#import "FCHomePageViewController.h"

#define TFTag 2000
#define PRICETAG 1000

@interface FCRecordViewController ()

- (void)selectPrice:(UIButton *)sender;//选择加价
- (void)refreshStarting:(NSNotification *)notifi;//刷新起点文字
- (void)refreshEnding:(NSNotification *)notifi;//刷新终点文字
- (void)keyboardWillShow:(NSNotification *)notify;

@end

@implementation FCRecordViewController
@synthesize passenger,coorUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack{
    [super goBack];
//    if (mainContent) {
//        [mainContent performSelector:@selector(showAnswerCar)];
//    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    for(UIView *sub in self.view.subviews)
    {
        for (UIView *text in sub.subviews)
        {
            if ([text isKindOfClass:[UITextField class]]) {
                UITextField *t = (UITextField *)text;
                [t resignFirstResponder];
            }
        }
    }
    
}

#define H_CONTROL_ORIGIN CGPointMake(20, 70)
- (void)viewDidLoad
{
    [super viewDidLoad];
    isUserLocation = YES;
    textStart.userInteractionEnabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNaviBar];
    self.strNaviTitle = @"叫车";
    [self createNaviBtnRight:[UIImage imageNamed:@"cancel"] title:nil];
    [btnNaviRight addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadContent];
    
    /* 通知中心 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStarting:) name:@"REFRESHSTARTING" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshEnding:) name:@"REFRESHENDING" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // get initalization parameters
    // 获得初始化参数，
//	NSString *initParam = [[NSString alloc] initWithFormat:
//						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
    
	// init the RecognizeControl
    // 初始化语音识别控件
//	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN initParam:initParam];
//	
    
    
    // Configure the RecognizeControl
    // 设置语音识别控件的参数,具体参数可参看开发文档
//	[_iFlyRecognizeControl setEngine:@"poi" engineParam:nil grammarID:nil];
//	[_iFlyRecognizeControl setSampleRate:16000];
//	_iFlyRecognizeControl.delegate = self;
    
    
//    UIButton *btnRecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnRecord setFrame:CGRectMake(100, 100, 120, 30)];
//    [btnRecord setTitle:@"按住说话" forState:UIControlStateNormal];
//    [btnRecord addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
//    [btnRecord addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnRecord];
//    
//    
//    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnPlay setFrame:CGRectMake(100, 150, 120, 30)];
//    [btnPlay setTitle:@"播放" forState:UIControlStateNormal];
//    [btnPlay addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnPlay];
//    
//    btnFly = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnFly setFrame:CGRectMake(100, 200, 120, 30)];
//    [btnFly setTitle:@"讯飞" forState:UIControlStateNormal];
//    [btnFly addTarget:self action:@selector(fly) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnFly];
    
    
//    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnSend setFrame:CGRectMake(100, 250, 120, 30)];
//    [btnSend setTitle:@"发送测试" forState:UIControlStateNormal];
//    [btnSend addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnSend];
    
//    NSError *error;
//    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
//    [audioSession setActive:YES error: &error];
//    
//    [self.view addSubview:_iFlyRecognizeControl];
	// Do any additional setup after loading the view.
}

- (void)setMainContent:(id)sender{
    mainContent = sender;
}

/*
 
 叫车界面 所有布局加载
 
 */
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
        [textField setTag:TFTag+i];
        if (i == 0) {
            textStart = textField;
            /* 消除文字 新需求无 */
//            btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *imgIcon = [UIImage imageNamed:@"icon_delete2"];
//            [btnClear setImage:imgIcon forState:UIControlStateNormal];
//            [btnClear setFrame:CGRectMake(imgInputBg.frame.size.width-10-imgIcon.size.width, (imgInputBg.frame.size.height-imgIcon.size.height)/2.0, imgIcon.size.width, imgIcon.size.height)];
//            [btnClear addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
//            [imgInputBg addSubview:btnClear];
            
            imgLocation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_location"]];
            CGRect frame = imgLocation.frame;
            frame.origin = CGPointMake(4, 5);
            imgLocation.frame = frame;
            [imgInputBg addSubview:imgLocation];
            
        }
        else {
            textField.placeholder = @"请输入目的地";
            textEnd = textField;
            
//            UIButton *btnTalk = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *imgIcon = [UIImage imageNamed:@"icon_mircophone"];
//            [btnTalk setImage:imgIcon forState:UIControlStateNormal];
//            [btnTalk setFrame:CGRectMake(imgInputBg.frame.size.width-10-imgIcon.size.width, (imgInputBg.frame.size.height-imgIcon.size.height)/2.0, imgIcon.size.width, imgIcon.size.height)];
//            [btnTalk addTarget:self action:@selector(clickTalkBtn) forControlEvents:UIControlEventTouchUpInside];
//            [imgInputBg addSubview:btnTalk];
        }
        
        [imgInputBg addSubview:textField];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 180, 40,50)];
    [label setText:@"加价:"];
    [label setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:label];
    
    UIImage *price = [UIImage imageNamed:@"selected"];
    UIImage *unPrice = [UIImage imageNamed:@"unselected"];
    for (int i = 0; i<5; i++) {
        UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [priceBtn setFrame:CGRectMake(0, 0, price.size.width, price.size.height)];
        [priceBtn setCenter:CGPointMake(label.frame.origin.x + label.frame.size.width/2 + (25+ price.size.width/2)*(i+1),label.center.y)];
        [priceBtn setBackgroundImage:unPrice forState:UIControlStateNormal];
        [priceBtn setBackgroundImage:price forState:UIControlStateSelected];
        [priceBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [priceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [priceBtn setTag:i+PRICETAG];
        switch (i) {
            case 0:
                priceBtn.selected = YES;
                [priceBtn setTitle:@"0元" forState:UIControlStateNormal];
                break;
            case 1:
                [priceBtn setTitle:@"5元" forState:UIControlStateNormal];
                break;
            case 2:
                [priceBtn setTitle:@"10元" forState:UIControlStateNormal];
                break;
            case 3:
                [priceBtn setTitle:@"15元" forState:UIControlStateNormal];
                break;
            case 4:
                [priceBtn setTitle:@"20元" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [priceBtn addTarget:self action:@selector(selectPrice:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:priceBtn];
    }
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_style1"];
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnSend setFrame:CGRectMake((self.view.frame.size.width-imgBtn.size.width)/2.0, 250, imgBtn.size.width, imgBtn.size.height)];
    [btnSend setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [btnSend setTitle:@"确认" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSend];
}

/*
 价格选择切换
 */
- (void)selectPrice:(UIButton *)sender
{
    sender.selected = YES;
    for (int i= PRICETAG; i<PRICETAG+5; i++) {
        if (i!=sender.tag) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i];
            btn.selected = NO;
        }
    }
}

/*
  起点赋值
 */
- (void)refreshStarting:(NSNotification *)notifi
{
    if (!_starting) {
        
    }
}

/*
  重点信息赋值
 */
- (void)refreshEnding:(NSNotification *)notifi
{
    if (!_ending) {
        
    }
}

- (void)keyboardWillShow:(NSNotification *)notify
{
    for(id sub in self.view.subviews)
    {
        if ([sub isKindOfClass:[UITextField class]]) {
            UITextField *t = (UITextField *)sub;
            [t resignFirstResponder];
        }
    }
}
/* 我的位置清除位置按钮  需求改变 */
//- (void)clickClearBtn{
//    [btnClear setHidden:YES];
//    [imgLocation setHidden:YES];
//    isUserLocation = NO;
//    textStart.userInteractionEnabled = YES;
//    [textStart becomeFirstResponder];
//}

/* 新需求无
- (void)clickTalkBtn{
    [self fly];
}

- (void)recordStart{
    NSError *error;
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
    NSLog(@"Using File called: %@",recordedTmpFile);
    //Setup the recorder to use this file and record to it.
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.
    //Found this in antother example, but Im fuzzy on this still.
    [recorder setDelegate:self];
    //We call this to start the recording process and initialize
    //the subsstems so that when we actually say "record" it starts right away.
    [recorder prepareToRecord];
    //Start the actual Recording
    [recorder record];
    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
}*/

/* 新需求无  注释掉 
//- (void)play{
//    NSError *error;
//    AVAudioPlayer * avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
//    [avPlayer prepareToPlay];
//    [avPlayer play];
//}

- (void)fly{
    if([_iFlyRecognizeControl start])
	{
		btnFly.userInteractionEnabled = NO;
	}
}
*/


- (void)send{
    
    if (!isUserLocation && textStart.text.length == 0) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入出发地" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
        return;
    }
    if (textEnd.text.length == 0) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入目的地" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [myAlertView show];
        return;
    }
    
    
    [FCHUD showWithStatus:@"正在发送"];
    
    if (!conversationRequest) {
        conversationRequest = [[FCConversationRequest alloc] init];
        [conversationRequest setDelegate:self];
    }
    
    NSDictionary *dict;
    if (isUserLocation) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",passenger.uid],@"passenger_id", [NSString stringWithFormat:@"%f",coorUser.latitude],@"start_lat",[NSString stringWithFormat:@"%f",coorUser.longitude],@"start_lng",
                textEnd.text,@"end",@"19:00",@"appointment",nil];
    }
    else {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSString stringWithFormat:@"%@",passenger.uid],@"passenger_id", @"国贸",@"start",
                textEnd.text,@"end",@"19:00",@"appointment",nil];
    }
    /*NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%@",passenger.uid],@"passenger_id", @"国贸",@"start",@"39.915",@"start_lat",@"116.405",@"start_lng",
                          textEnd.text,@"end",@"19:00",@"appointment",nil];*/
    
    [conversationRequest createConversation:[NSMutableDictionary dictionaryWithObject:dict forKey:@"trip"]];
    /*
    
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = @"api/trips";
    response.type = POST;
    [response startQueryAndParse:[NSMutableDictionary dictionaryWithObject:dict forKey:@"trip"]];*/
}

- (void)queryCFinished:(NSMutableDictionary *)dict{
    [FCHUD dismiss];
    if (mainContent) {
        FCHomePageViewController *controller = (FCHomePageViewController *)mainContent;
        controller.tripID = [[dict valueForKey:@"trip"] valueForKey:@"id"];
        NSArray *drivers = [dict valueForKey:@"drivers"];
        
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i = 0; i < drivers.count; i++) {
            NSDictionary *dt = [drivers objectAtIndex:i];
            Driver *driver = [[Driver alloc] init];
            driver.uid = [dt valueForKey:@"id"];
            driver.car_license = [dt valueForKey:@"car_license"];
            driver.car_service_number = [dt valueForKey:@"car_service_number"];
            driver.car_type = [dt valueForKey:@"car_type"];
            driver.distance = [dt valueForKey:@"distance"];
            driver.mobile = [dt valueForKey:@"mobile"];
            driver.name = [dt valueForKey:@"name"];
            driver.rate = [dt valueForKey:@"rate"];
            [temp addObject:driver];
        }
        
        [mainContent performSelector:@selector(showWaitingPanel:) withObject:temp];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/*  关于语音识别 新需求无 
 
#pragma mark
#pragma mark 接口回调

//	recognition end callback
//  识别结束回调函数，当整个会话过程结束时候会调用这个函数
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"识别结束回调finish.....");
	//[self enableButton];
    btnFly.userInteractionEnabled = YES;
	
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
	
}

//  set the textView
//  设置textview中的文字，既返回的识别结果
- (void)onUpdateTextView:(NSString *)sentence
{
	NSLog(@"%@",sentence);
//	NSString *str = [[NSString alloc] initWithFormat:@"%@%@", _textView.text, sentence];
//	_textView.text = str;
//	
//	NSLog(@"str");
}

- (void)onRecognizeResult:(NSArray *)array
{
    //  execute the onUpdateTextView function in main thread
    //  在主线程中执行onUpdateTextView方法
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

//  recognition result callback
//  识别结果回调函数
- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	//[self onRecognizeResult:resultArray];
    if (resultArray.count==0) {
        return;
    }
    NSDictionary *dict = [resultArray objectAtIndex:0];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSString *strResult = [[resultArray objectAtIndex:0] valueForKey:@"NAME"];
    [self performSelectorOnMainThread:@selector(setSoundResult:) withObject:strResult waitUntilDone:NO];
	NSLog(@"%@",resultArray);
}

- (void)setSoundResult:(NSString *)strResult{
    textEnd.text = strResult;
}

- (void)recordEnd{
    [recorder stop];
}
 
 */



#pragma mark
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    FCInputLocationViewController *inputLocation = [[FCInputLocationViewController alloc] initWithNibName:@"InputLocationViewController" bundle:nil];
    if (textField.tag==TFTag) {
        inputLocation.starting = YES;
    }else{
        inputLocation.starting = NO;
    }
    inputLocation.passenger = self.passenger;
    [self presentModalViewController:inputLocation animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
