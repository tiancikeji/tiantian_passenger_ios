//
//  FCHomePageViewController.m
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCHomePageViewController.h"
#import "FCRecordViewController.h"
#import "FCDriverAnnotationView.h"
#import "FCConversationRequest.h"
#import "FCDriverAnnotation.h"
#import "AppDelegate.h"
#import "Conversation.h"
//#import "FCLoginViewController.h"

@interface FCHomePageViewController ()

@end

@implementation FCHomePageViewController
@synthesize converID,tripID,passenger,arrayReceiveDrivers;

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
    
    bubbleCanUse = YES;
    myMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    myMapView.delegate = self;
    [myMapView setShowsUserLocation:YES];
    [self.view addSubview:myMapView];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
    
//    coorUser = myMapView.userLocation.coordinate;
//    newRegion.center = coorUser;


    
    [self loadNoteView];//加载
    [self loadToolBar];
    
//    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btnLocation setFrame:CGRectMake(10, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-40, 80, 30)];
//    [btnLocation setTitle:@"定位" forState:UIControlStateNormal];
//    
//    [self.view addSubview:btnLocation];
    
    
    
//    FCDriverAnnotation* annotation = [[FCDriverAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = 39.915;
//    coor.longitude = 116.404;
//    annotation.coordinate = coor;
//    [myMapView addAnnotation:annotation];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"]) {
        passenger = [[Passenger alloc] init];
        passenger.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    }
    
    
    [FCHUD showWithStatus:@"正在加载"];
    [self getDrivers];

    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getDrivers) userInfo:nil repeats:YES];
    //[self showDriverContent:YES];
	// Do any additional setup after loading the view.
}

/*
 
 现在打车按钮背景
 
 */
- (void)loadToolBar{
    imgToolbar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_toolbar.png"]];
    imgToolbar.userInteractionEnabled = YES;
    CGRect frame = imgToolbar.frame;
    frame.origin = CGPointMake(0, self.view.frame.size.height-frame.size.height);
    imgToolbar.frame = frame;
    [self.view addSubview:imgToolbar];
    
    [self showCallBtn:YES];
    
}

/*
 
 进入登陆注册界面 新版本不需要 待注释
 
 */
//- (void)showLoginPage{
//    FCLoginViewController *controller = [[FCLoginViewController alloc] init];
//    controller.homePageCtrl = self;
//    UINavigationController *naviCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
//    [self presentModalViewController:naviCtrl animated:YES];
//}

/*
 
 取消打车和现在打车 两个按钮的切换
 
 */
- (void)showCallBtn:(BOOL)status{
    if (status) {
        if (!btnCall) {
            btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *imgCall = [UIImage imageNamed:@"btn_call.png"];
            UIImage *imgCallHighlight = [UIImage imageNamed:@"btn_callA.png"];
            [btnCall setFrame:CGRectMake(0, 0, imgCall.size.width, imgCall.size.height)];
            [btnCall setCenter:CGPointMake(imgToolbar.frame.size.width/2, imgToolbar.frame.size.height/2)];
            [btnCall setBackgroundImage:imgCall forState:UIControlStateNormal];
            [btnCall setTitle:@"开始叫车" forState:UIControlStateNormal];
            [btnCall.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [btnCall setBackgroundImage:imgCallHighlight forState:UIControlStateHighlighted];
            [btnCall addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];
            [imgToolbar addSubview:btnCall];
        }
        btnCall.hidden = NO;
        
        if (btnCancel) {
            btnCancel.hidden = YES;
            btnOnCar.hidden = YES;
        }
    }
    else {
        if (!btnCancel) {
            for (int i = 0; i < 2; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *imgNormal = [UIImage imageNamed:i==0?@"car_cancel.png":@"on_car.png"];
                [btn setImage:imgNormal forState:UIControlStateNormal];
                [btn setFrame:CGRectMake(8+155*i, (imgToolbar.frame.size.height-imgNormal.size.height)/2.0, imgNormal.size.width, imgNormal.size.height)];
                [btn addTarget:self action:@selector(clickToolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
                if (i==0) {
                    btnCancel=btn;
                }
                else{
                    btnOnCar=btn;
                }
                btn.tag = i;
                [imgToolbar addSubview:btn];
            }
        }
        btnCancel.hidden = NO;
        btnOnCar.hidden = NO;
        if (btnCall) {
            btnCall.hidden = YES;
        }
    }
}

/*
 
 控制司机信息的显示和消失
 
 */
- (void)showDriverContent:(BOOL)status{
    if (status) {
        if (!driverInfoView) {
            driverInfoView = [[FCDriverInfoView alloc] initWithFrame:CGRectMake(10, 10, 300, 115)];
            [driverInfoView performSelector:@selector(loadContent)];
        }
        driverInfoView.hidden = NO;
        [self.view addSubview:driverInfoView];
        [driverInfoView performSelector:@selector(updateUserInfo)];
    }
    else {
        if (driverInfoView) {
            driverInfoView.hidden = YES;
        }
    }
}

/*
 
 五公里范围内 导航view
 
 */
- (void)loadNoteView{
    imgNote = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"driver_count.png"]];
    imgNote.userInteractionEnabled = YES;
    CGRect frame = imgNote.frame;
    frame.origin = CGPointMake(9, 9);
    imgNote.frame = frame;
    [self.view addSubview:imgNote];
    
    UIImage *imgLocation = [UIImage imageNamed:@"btn_refresh.png"];
    UIImage *imgLocationHighlight = [UIImage imageNamed:@"btn_refreshA.png"];
    UIButton *btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLocation.frame = CGRectMake(0, 0, imgLocation.size.width, imgLocation.size.height);
    [btnLocation setImage:imgLocation forState:UIControlStateNormal];
    [btnLocation setImage:imgLocationHighlight forState:UIControlStateHighlighted];
    [btnLocation addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchUpInside];
    [imgNote addSubview:btnLocation];
    
    UIImage *imgProfile = [UIImage imageNamed:@"btn_setting.png"];
    UIImage *imgProfileHighlight = [UIImage imageNamed:@"btn_settingA.png"];
    UIButton *btnProfile = [UIButton buttonWithType:UIButtonTypeCustom];
    btnProfile.frame = CGRectMake(imgNote.frame.size.width-imgProfile.size.width, 0, imgProfile.size.width, imgProfile.size.height);
    [btnProfile setImage:imgProfile forState:UIControlStateNormal];
    [btnProfile setImage:imgProfileHighlight forState:UIControlStateHighlighted];
    [btnProfile addTarget:self action:@selector(showProfile) forControlEvents:UIControlEventTouchUpInside];
    [imgNote addSubview:btnProfile];
    
    if (!labelSearchCount) {
        labelSearchCount = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, imgNote.frame.size.width-88, imgNote.frame.size.height)];
        labelSearchCount.backgroundColor = [UIColor clearColor];
        labelSearchCount.font = [UIFont systemFontOfSize:14];
        labelSearchCount.textAlignment = UITextAlignmentCenter;
    }
    [imgNote addSubview:labelSearchCount];
}

/*
 
 根据当前位置坐标 和公里范围 获取所有司机的坐标和其他信息
 
 */
- (void)getDrivers{
    [self performSelector:@selector(getDrivers) withObject:nil afterDelay:10];
    //NSString *strToken = [[KTData sharedObject] getToken];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /* 
     此处获取司机的经纬度范围随着用户拖动地图 显示范围不断变化 传递的是显示范围 而非五公里
     
     新需求:显示可视范围内的司机 接口需改变
     */
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",coorUser.latitude],@"driver[lat]",[NSString stringWithFormat:@"%f",coorUser.longitude],@"driver[lng]", @"5",@"scope",nil];
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"39.915",@"driver[lat]",@"116.404",@"driver[lng]", @"5",@"scope",nil];
    
    if (appDelegate.strDeviceToken) {
        [dict setObject:appDelegate.strDeviceToken forKey:@"iosDevice"];
    }
    
    FCServiceResponse *response = [[FCServiceResponse alloc] init];
    [response setDelegate:self];
    response.strUrl = /*@"api/category.json";*/@"api/drivers";
    response.type = GET;
    [response startQueryAndParse:dict];
}

/*
 
 获取司机信息成功 存储司机信息 地图上更新司机位置 更新状态栏司机数量
 
 */
- (void)queryFinished:(NSString *)strData{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *parseError = nil;
    NSMutableDictionary *dict = (NSMutableDictionary *)[jsonParser objectWithString:strData error:&parseError];
    //NSLog(@"%@",dict);
    
    if (dict) {
        if (arrayDrivers) {
            [arrayDrivers removeAllObjects];
        }
        else{
            arrayDrivers = [[NSMutableArray alloc] initWithCapacity:1];
        }
        NSMutableArray *array = [dict valueForKey:@"drivers"];
        for (int i = 0; i < array.count; i++) {
            NSMutableDictionary *dict = [array objectAtIndex:i];
            Driver *driver = [[Driver alloc] init];
            driver.car_license = [dict valueForKey:@"car_license"];
            driver.car_service_number = [dict valueForKey:@"car_service_number"];
            driver.car_type = [dict valueForKey:@"car_type"];
            driver.lat = [dict valueForKey:@"lat"];
            driver.lng = [dict valueForKey:@"lng"];
            driver.mobile = [dict valueForKey:@"mobile"];
            driver.name = [dict valueForKey:@"name"];
            driver.rate = [dict valueForKey:@"rate"];
            driver.status = [dict valueForKey:@"status"];
            
            [arrayDrivers addObject:driver];
        }
    }
    [self addDriverLocation];//更新地图司机位置
    [self updateSearchCount];
    [FCHUD dismiss];
}

/*
 
 更新状态栏司机数量
 
 */
- (void)updateSearchCount{
    if ([arrayAnn count] == 0) {
        labelSearchCount.text = @"抱歉，您周围暂时没有出租车";
        return;
    }
    labelSearchCount.text = [NSString stringWithFormat:@"%d辆出租车，5公里范围",[arrayAnn count]];
}

/*
 
 地图上添加司机位置
 
 */
- (void)addDriverLocation{
    if (arrayAnn) {
        [myMapView removeAnnotations:arrayAnn];
        [arrayAnn removeAllObjects];
    }
    else{
        arrayAnn = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < arrayDrivers.count; i++) {
        Driver *driver = [arrayDrivers objectAtIndex:i];
        FCDriverAnnotation* annotation = [[FCDriverAnnotation alloc]initWithLatitude:driver.lat.floatValue longitude:driver.lng.floatValue];
//        CLLocationCoordinate2D coor;
//        coor.latitude = driver.lat.floatValue;
//        coor.longitude = driver.lng.floatValue;
        annotation.driver = driver;
        
        [arrayAnn addObject:annotation];
//        annotation.coordinate = coor;
    }
    [myMapView addAnnotations:arrayAnn];
}

/*
 
  刷新地图
 
 */
- (void)showLocation{
    [locationManager startUpdatingLocation];
    [myMapView setShowsUserLocation:YES];
    newRegion.center = coorUser;
    [myMapView setRegion:newRegion];
}

NSString* const AnnotationReuseIdentifier = @"AnnotationReuse";

/*
 
 现在打车 
 
 */
- (void)clickCallBtn{
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"]) {
//        [self showLoginPage];
//        return;
//    }
    FCRecordViewController *recordController = [[FCRecordViewController alloc] init];
    recordController.passenger = passenger;
    recordController.coorUser = coorUser;
    [self.navigationController pushViewController:recordController animated:YES];
    [recordController performSelector:@selector(setMainContent:) withObject:self];
}

//click cancel/oncar btn
- (void)clickToolBarBtn:(id)sender{
    int tag = ((UIButton *)sender).tag;
    [self updateConversations:tag==0?ConversationTypeRefuse:ConversationTypeAccept];
    [self showCallBtn:YES];
    [self showDriverContent:NO];
    imgNote.hidden = NO;
}

#pragma mark
#pragma mark - BMKMapViewDelegate Methods

//地图区域改变
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    userRegion = myMapView.region;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    coorUser = userLocation.coordinate;
    newRegion.center = coorUser;
    newRegion.span.latitudeDelta = 0.03;
    newRegion.span.longitudeDelta = 0.03;
    [myMapView setRegion:newRegion];
    [locationManager stopUpdatingLocation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[FCDriverAnnotation class]]){
        static NSString *annotationIdentifier = @"AnnotationIdentifier";
        BMKPinAnnotationView *pinView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            BMKPinAnnotationView* customPinView = [[BMKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            
            Driver *driverInfo = ((FCDriverAnnotation *)annotation).driver;
            if (driverInfo.status.intValue == 0) {
                customPinView.pinColor = BMKPinAnnotationColorGreen;
            }
            else {
                customPinView.pinColor = BMKPinAnnotationColorRed;
            }
            
            customPinView.animatesDrop = NO;
            customPinView.canShowCallout = NO;
            return customPinView;
        }
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)aView {
    id<BMKAnnotation> annotation = aView.annotation;
    if (!annotation || ![aView isSelected])
        return;
    
    if (!bubbleCanUse) {
        return;
    }
    if ([annotation isKindOfClass:[FCDriverAnnotation class]]) {
        [self showDriverInfo:((FCDriverAnnotation *)annotation).driver];
    }

}

- (void)showDriverInfo:(Driver *)driverInfo{
    if (!driverInfoView) {
        driverInfoView = [[FCDriverInfoView alloc] initWithFrame:CGRectMake(10, 10, 300, 115)];
        [driverInfoView performSelector:@selector(loadContent)];
    }
    driverInfoView.hidden = NO;
    [self.view addSubview:driverInfoView];
    driverInfoView.driverInfo = driverInfo;
    [driverInfoView performSelector:@selector(updateUserInfo)];
    /*
    if (!viDriverInfo) {
        viDriverInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        UIImageView *bg = [[UIImageView alloc] initWithFrame:viDriverInfo.bounds];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.5;
        [viDriverInfo addSubview:bg];
        
        labelCarLicense = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, 20)];
        labelMobile = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 200, 20)];
        labelName = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 200, 20)];
        labelRate = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 200, 20)];
        
        [viDriverInfo addSubview:labelCarLicense];
        [viDriverInfo addSubview:labelMobile];
        [viDriverInfo addSubview:labelName];
        [viDriverInfo addSubview:labelRate];
        
        for (id element in viDriverInfo.subviews) {
            UILabel *lb = (UILabel *)element;
            if ([lb isKindOfClass:[UILabel class]]) {
                lb.font = [UIFont systemFontOfSize:14];
                lb.textColor = [UIColor whiteColor];
                lb.backgroundColor = [UIColor clearColor];
            }
        }
    }
    labelCarLicense.text = driverInfo.car_license;
    labelMobile.text = driverInfo.mobile;
    labelName.text = driverInfo.name;
    labelRate.text = [NSString stringWithFormat:@"%@星",driverInfo.rate];
    
    [self.view addSubview:viDriverInfo];
    */
    
}

- (void)showRequestView:(BOOL)status{
    if (status) {
        if (!waitingRequestView) {
            waitingRequestView = [[FCWaitingRequestView alloc] initWithFrame:CGRectMake(10, 10, 300, 65)];
            [waitingRequestView performSelector:@selector(loadContent)];
        }
        waitingRequestView.hidden = NO;
        [self.view addSubview:waitingRequestView];
        [waitingRequestView performSelector:@selector(updateStatus)];
    }
    else {
        if (waitingRequestView) {
            waitingRequestView.hidden = YES;
        }
    }
}

/*
 
  控制是否显示取消打车按钮
 
 */
- (void)showCancelBtn:(BOOL)status{
    if (status) {
        if (!btnCancelRequest) {
            btnCancelRequest = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *img = [UIImage imageNamed:@"cancel_request.png"];
            [btnCancelRequest setBackgroundImage:img forState:UIControlStateNormal];
            [btnCancelRequest setBackgroundImage:[UIImage imageNamed:@"cancel_requestA"] forState:UIControlStateHighlighted];
            [btnCancelRequest setTitle:@"取消叫车" forState:UIControlStateNormal];
            [btnCancelRequest.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [btnCancelRequest setFrame:CGRectMake((imgToolbar.frame.size.width-img.size.width)/2.0, (imgToolbar.frame.size.height-img.size.height)/2.0, img.size.width, img.size.height)];
            [btnCancelRequest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnCancelRequest addTarget:self action:@selector(clickCancelRequestBtn) forControlEvents:UIControlEventTouchUpInside];
            [imgToolbar addSubview:btnCancelRequest];
        }
        btnCancelRequest.hidden = NO;
        btnCall.hidden = YES;
    }
    else {
        btnCancelRequest.hidden = YES;
        btnCall.hidden = NO;
    }
}

/*
 点击取消打车按钮
 */
- (void)clickCancelRequestBtn{
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(getMyTripConversations) object:nil];
    [self showCancelBtn:NO];
    [self showRequestView:NO];
    
    bubbleCanUse = YES;
}

#define CONVERSATION_REFRESH_TIME 10
- (void)showWaitingPanel:(NSMutableArray *)array{
    bubbleCanUse = NO;
    arrayReceiveDrivers = array;
    [self showRequestView:YES];
    [self showCancelBtn:YES];
    
    waitingRequestView.labelCount.text = [NSString stringWithFormat:@"共有%d辆出租车收到消息",array.count];
    
    [self performSelector:@selector(getMyTripConversations) withObject:nil afterDelay:CONVERSATION_REFRESH_TIME];
}

- (void)showAnswerCar{
    [self showCallBtn:NO];
    [self showDriverContent:YES];
    imgNote.hidden = YES;
}

- (void)showProfile{
}


#pragma mark - update conversations

- (void)updateConversations:(enum ConversationType)type{
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(getMyTripConversations) object:nil];
    bubbleCanUse = YES;
    if (!conversationRequest) {
        [self createConversationRequest];
    }
    [conversationRequest updateConversation:converID status:type];
    
}

- (void)createConversationRequest{
    conversationRequest = [[FCConversationRequest alloc] init];
    [conversationRequest setDelegate:self];
}

- (void)getMyTripConversations{
    [self performSelector:@selector(getMyTripConversations) withObject:nil afterDelay:CONVERSATION_REFRESH_TIME];
    
    if (!conversationRequest) {
        [self createConversationRequest];
    }
    conversationRequest.passenger = passenger;
    [conversationRequest getConversation:converID];
}

- (void)getConversationFinished:(NSMutableArray *)array{
    if (array.count==0) {
        return;
    }
    Conversation *conversation = [array lastObject];
    converID = conversation._id;
    if (conversation.status.intValue == 1) {
        [self showAnswerCar];
        
        [self showCancelBtn:NO];
        [self showRequestView:NO];
        imgNote.hidden = YES;
        [self showCallBtn:NO];
        
        for (int i = 0; i < arrayReceiveDrivers.count; i++) {
            Driver *dri = [arrayReceiveDrivers objectAtIndex:i];
            if (dri.uid.intValue == [conversation.to intValue]) {
                [self showDriverInfo:dri];
                break;
            }
            
        }
    }
}

- (void)queryCFinished:(NSMutableDictionary *)dict{
    NSLog(@"%@",dict);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
