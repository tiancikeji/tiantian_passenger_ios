//
//  FCHomePageViewController.m
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCHomePageViewController.h"
#import "FCDriverAnnotationView.h"
#import "FCConversationRequest.h"
#import "FCDriverAnnotation.h"
#import "AppDelegate.h"
#import "Conversation.h"
#import "FCRecordViewController.h"
#import "FCSettingsViewController.h"
//#import "FCLoginViewController.h"

@interface FCHomePageViewController ()

@property (nonatomic, strong) FCRecordViewController *recordController;

- (void)loadToolBar;//加载工具条图片
- (void)showCallBtn:(BOOL)status;//控制 “现在打车”按钮 和 取消打车时弹出是否打车界面 的切换
- (void)showDriverContent:(BOOL)status;//控制 司机信息栏显示和隐藏
- (void)loadNoteView;//进入地图界面时 加载 司机数量信息的信息栏
- (void)getDrivers;//从服务器获取用户周围司机数量及位置信息
- (void)updateSearchCount;//更新搜索司机数量
- (void)addDriverLocation;//添加司机位置标注
- (void)showLocation;//刷新地图
- (void)clickCallBtn;//点击现在打车按钮
- (void)clickToolBarBtn:(id)sender;//点击取消打车或者继续打车按钮
- (void)showDriverInfo:(Driver *)driverInfo;//展示司机信息栏
- (void)showRequestView:(BOOL)status;//显示等待司机响应倒计时栏
- (void)showCancelBtn:(BOOL)status;//控制是否显示取消打车按钮
- (void)clickCancelRequestBtn;//点击取消打车按钮 等待响应状态栏消失 取消对话请求
- (void)showWaitingPanel:(NSMutableArray *)array;//显示有多少司机收到响应的状态栏
- (void)showAnswerCar;//显示响应车的司机信息
- (void)showCancelView;//显示取消选择
- (void)clickAppointCall;//点击预约叫车

@end

@implementation FCHomePageViewController
@synthesize converID,passenger,arrayReceiveDrivers;

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
    
    bubbleCanUse = NO;
    
    myMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    myMapView.delegate = self;
    [myMapView setShowsUserLocation:YES];
    [self.view addSubview:myMapView];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    [self loadNoteView];//加载
    [self loadToolBar];
    
    [self performSelector:@selector(showLocation) withObject:nil afterDelay:3];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (![app isConnectionAvailable]  ) {
        [FCHUD showErrorWithStatus:@"请你连接网络"];
    }
    {
        [FCHUD showWithStatus:@"正在加载"];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"haveLogin"]) {
            passenger = [[Passenger alloc] init];
            passenger.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        }
        [self performSelector:@selector(getDrivers) withObject:nil afterDelay:10];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showLocation];
}

//添加用户位置标注点
- (void)adUserAnnotation
{
    if (_userAnnotation) {
        [myMapView removeAnnotation:_userAnnotation];
    }else{
        _userAnnotation = [[BMKPointAnnotation alloc] init];
    }
    [_userAnnotation setTitle:_myLocation];
    [_userAnnotation setCoordinate:_coorUser];
    [myMapView addAnnotation:_userAnnotation];
}

- (void)setMapCenter:(CLLocationDegrees)lat andLng:(CLLocationDegrees)lng
{
    newRegion.center.latitude = lat;
    newRegion.center.longitude = lng;
    newRegion.span.latitudeDelta = 0.03;
    newRegion.span.longitudeDelta = 0.03;
    [myMapView setRegion:newRegion];
    [self adUserAnnotation];
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
 
 取消打车和现在打车 两个按钮的切换
 
 */
- (void)showCallBtn:(BOOL)status{
    if (status) {
        if (!btnCall) {
            btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
//            UIImage *imgCall = [UIImage imageNamed:@"btn_call.png"];
//            UIImage *imgCallHighlight = [UIImage imageNamed:@"btn_callA.png"];
            UIImage *imgCall = [UIImage imageNamed:@"on_car.png"];
            UIImage *imgCallHighlight = [UIImage imageNamed:@"on_car.png"];

            
            [btnCall setFrame:CGRectMake(0, 0, imgCall.size.width, imgCall.size.height)];
            [btnCall setCenter:CGPointMake(imgToolbar.frame.size.width/2-80, imgToolbar.frame.size.height/2)];
            [btnCall setBackgroundImage:imgCall forState:UIControlStateNormal];
            [btnCall setTitle:@"开始叫车" forState:UIControlStateNormal];
            [btnCall.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [btnCall setBackgroundImage:imgCallHighlight forState:UIControlStateHighlighted];
            [btnCall addTarget:self action:@selector(clickCallBtn) forControlEvents:UIControlEventTouchUpInside];
            [imgToolbar addSubview:btnCall];
            
            _appointCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *imgAppoint = [UIImage imageNamed:@"on_car.png"];
            UIImage *imgAppointHighlight = [UIImage imageNamed:@"on_car.png"];
            [_appointCallBtn setFrame:CGRectMake(0, 0, imgCall.size.width, imgCall.size.height)];
            [_appointCallBtn setCenter:CGPointMake(imgToolbar.frame.size.width/2+80, imgToolbar.frame.size.height/2)];
            [_appointCallBtn setBackgroundImage:imgAppoint forState:UIControlStateNormal];
            [_appointCallBtn setTitle:@"预约叫车" forState:UIControlStateNormal];
            [_appointCallBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [_appointCallBtn setBackgroundImage:imgAppointHighlight forState:UIControlStateHighlighted];
            [_appointCallBtn addTarget:self action:@selector(clickAppointCall) forControlEvents:UIControlEventTouchUpInside];
            [imgToolbar addSubview:_appointCallBtn];
            
        }
        btnCall.hidden = NO;
        
        if (btnCancel) {
            btnCancel.hidden = YES;
            btnOnCar.hidden = YES;
            _appointCallBtn.hidden = YES;
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

- (void)clickAppointCall
{
    FCAppointViewController *appoint = [[FCAppointViewController alloc] init];
    [self.navigationController pushViewController:appoint animated:YES];
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",_coorUser.latitude],@"driver[lat]",[NSString stringWithFormat:@"%f",_coorUser.longitude],@"driver[lng]", @"5",@"scope",nil];
    
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

#pragma mark
#pragma mark - FCServiceResponseDelegate

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

- (void)queryError:(NSError *)errorConnect
{
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
        annotation.driver = driver;
        
        [arrayAnn addObject:annotation];
    }
    [myMapView addAnnotations:arrayAnn];
}

/*
 
  刷新地图
 
 */
- (void)showLocation{
    [locationManager startUpdatingLocation];
    [myMapView setShowsUserLocation:YES];
}

NSString* const AnnotationReuseIdentifier = @"AnnotationReuse";

/*
 
 现在打车 
 
 */
- (void)clickCallBtn{
    _recordController = [[FCRecordViewController alloc] init];
    _recordController.passenger = passenger;
    _recordController.coorUser = _coorUser;
    _recordController.myLocationName = _myLocation;
    [self.navigationController pushViewController:_recordController animated:YES];
    [_recordController performSelector:@selector(setMainContent:) withObject:self];
}

//click cancel/oncar btn
- (void)clickToolBarBtn:(id)sender{
//    int tag = ((UIButton *)sender).tag;
    bubbleCanUse = NO;
//    [self updateConversations:tag==0?ConversationTypeRefuse:ConversationTypeAccept];
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
    _coorUser = userLocation.coordinate;
    [self setMapCenter:_coorUser.latitude andLng:_coorUser.longitude];
    [myMapView setShowsUserLocation:NO];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[FCDriverAnnotation class]]){
        static NSString *annotationIdentifier = @"AnnotationIdentifier";
        BMKAnnotationView *pinView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            BMKAnnotationView* customPinView = [[BMKAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            
            Driver *driverInfo = ((FCDriverAnnotation *)annotation).driver;
            if (driverInfo.status.intValue == 0) {
                customPinView.image = [UIImage imageNamed:@"green.png"];
            }
            else {
                customPinView.image = [UIImage imageNamed:@"orange.png"];
            }
            
//            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = NO;
            return customPinView;
        }else{
            pinView.annotation = annotation;
        }
       return pinView;

    }
    else if([annotation isKindOfClass:[BMKPointAnnotation class]]){
        static NSString *annotationIdentifier = @"UserAnnotationIdentifier";
        BMKPinAnnotationView* pinView = (BMKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            BMKPinAnnotationView *userPinView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            userPinView.image = [UIImage imageNamed:@"user.png"];
            userPinView.canShowCallout = YES;
            return userPinView;
        }else{
            pinView.annotation = annotation;
        }
        return pinView;
    }

    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)aView {
    id<BMKAnnotation> annotation = aView.annotation;
//    BMKPointAnnotation *userAnnotation = (BMKPointAnnotation *)annotation;
    if (!annotation || ![aView isSelected])
        return;
    
//    if (!bubbleCanUse) {
//        if ([annotation isKindOfClass:[FCDriverAnnotation class]]) {
//        }else if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
//            NSLog(@"BMKPointAnnotation");
//        }
//        return;
//    }
    if ([annotation isKindOfClass:[FCDriverAnnotation class]]) {
//        [self showDriverInfo:((FCDriverAnnotation *)annotation).driver];
    }else if ([annotation isKindOfClass:[BMKPointAnnotation class]]){

    }
}

#pragma mark
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *detail =placemark.thoroughfare;
            NSString *cityName =placemark.locality;
            NSString *name = placemark.name;
//            NSString *thoroughFare = placemark.thoroughfare;
            NSString *subThoroughFare = placemark.subThoroughfare;
            if (cityName == NULL || [cityName isEqualToString:@""]|| !cityName) {
            }else{
                myCityName = [NSString stringWithFormat:@"%@",cityName];
            }
            if ((detail == NULL) || [detail isEqualToString:@""] ||!detail) {
            }else{
                myDetailAddress = [NSString stringWithFormat:@"%@",detail];
            }
            if (name == NULL || [name isEqualToString:@""]|| !name) {
            }else{
                myLocationName = [NSString stringWithFormat:@"%@",name];
            }
            if (subThoroughFare == NULL || [subThoroughFare isEqualToString:@""] ||!subThoroughFare ) {
            }else{
                mySubAddress = [NSString stringWithFormat:@"%@",subThoroughFare];
            }
        }
    }];
    NSLog(@"%@,%@,%@,%@",myCityName,myDetailAddress,myLocationName,mySubAddress);
    _myLocation = [NSString stringWithFormat:@"%@%@%@",myCityName,myDetailAddress,mySubAddress];
    if ([_myLocation isEqualToString:@""]) {
        _myLocation = @"无";
    }
    [self adUserAnnotation];
//    [locationManager stopUpdatingLocation];
}

/* 司机应答后 显示司机信息 */
- (void)showDriverInfo:(Driver *)driverInfo{
    if (!driverInfoView) {
        driverInfoView = [[FCDriverInfoView alloc] initWithFrame:CGRectMake(10, 10, 300, 115)];
        [driverInfoView performSelector:@selector(loadContent)];
    }
    driverInfoView.hidden = NO;
    [self.view addSubview:driverInfoView];
    driverInfoView.driverInfo = driverInfo;
    [driverInfoView performSelector:@selector(updateUserInfo)];
}

/* 控制显示和隐藏等待司机应答状态栏 */
- (void)showRequestView:(BOOL)status{
    if (status) {
        if (!waitingRequestView) {
            waitingRequestView = [[FCWaitingRequestView alloc] initWithFrame:CGRectMake(10, 10, 300, 65)];
            waitingRequestView.delegate = self;
            [self.view addSubview:waitingRequestView];
            [waitingRequestView performSelector:@selector(loadContent)];
        }else{
            [waitingRequestView performSelector:@selector(updateStatus)];
        }
        waitingRequestView.hidden = NO;
    }
    else {
        if (waitingRequestView) {
            [waitingRequestView stopAllTimer];
            waitingRequestView.hidden = YES;
        }
    }
}


#pragma mark
#pragma mark FCWaitingRequestViewDelegate

//倒计时结束 自动弹出是否继续打车
- (void)countDownEnding
{
    [self showCancelView];
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
    }else {
        btnCancelRequest.hidden = YES;
        btnCall.hidden = NO;
    }
}

/*
 点击取消打车按钮
 */
- (void)clickCancelRequestBtn{

    [self showCancelView];
}

/*
 显示取消打车提示选择
 */
- (void)showCancelView
{
    if (!_translucentView) {
        _translucentView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_translucentView setBackgroundColor:[UIColor blackColor]];
        [_translucentView setAlpha:0.5];
        [self.view addSubview:_translucentView];
    }else{
        _translucentView.hidden = NO;
    }
    if (!_cancelView) {
        _cancelView = [[CancelView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-173, 0, 0)];
        [_cancelView setDelegate:self];
        [self.view addSubview:_cancelView];
    }else{
        _cancelView.hidden = NO;
        _reasonView.hidden = YES;
    }
    if ([waitingRequestView.time.text isEqualToString:@"0"]) {
        [_cancelView.titleLabel setText:@"暂时没有司机应答，您是否要继续叫车?"];
    }else{
        [_cancelView.titleLabel setText:@"确定要取消本次叫车服务吗?"];
    }
}

#pragma mark
#pragma mark CancelViewDelegate

/*
 
 确定取消叫车
 1、等待司机应答时，点击取消叫车-》选择取消原因-》取消对话 显示正常地图界面
 2、司机已应答后，点击取消叫车-》确认取消-》取消原因-》更新对话状态为拒绝 显示正常地图界面
 
*/

- (void)cancelCall
{
    if (!_reasonView) {
        _reasonView = [[CancelReasonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_reasonView setFrame:CGRectMake(0, self.view.frame.size.height-_reasonView.frame.size.height, _reasonView.frame.size.width, _reasonView.frame.size.height)];
        _reasonView.delegate = self;
        [self.view addSubview:_reasonView];
    }else{
        _reasonView.hidden = NO;
    }
}

/*
 
 继续叫车 
 等待应答过程中取消叫车-》继续叫车 取消界面消失即可
 应答最后一秒弹出取消叫车和继续叫车-》继续叫车 重新发送刚刚发送的叫车信息
 
 */
- (void)continueCall
{
    _translucentView.hidden = YES;
    _cancelView.hidden = YES;
    
    if ([waitingRequestView.time.text isEqualToString:@"0"] ) {
        [waitingRequestView stopAllTimer];
        [_recordController performSelector:@selector(send) withObject:nil withObject:nil];
    }
}

#pragma mark
#pragma mark CancelReasonViewDelegate

- (void)clickReason:(UIButton *)sender
{
    if (waitingRequestView.hidden == NO) {
        [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(getMyTripConversations) object:nil];
        [self showRequestView:NO];
        [waitingRequestView stopAllTimer];
    }else{
        NSString *reason = sender.titleLabel.text;
        [self updateConversations:ConversationTypeRefuse andReason:reason];
        [self showCallBtn:YES];
        [self showDriverContent:NO];
        imgNote.hidden = NO;
        [self showAllAnnotation:YES];
    }
    [self showCancelBtn:NO];
    bubbleCanUse = YES;
    _translucentView.hidden = YES;
    _cancelView.hidden = YES;
    _reasonView.hidden = YES;
}

#define CONVERSATION_REFRESH_TIME 10

/*
 显示有多少司机收到应答界面
 */
- (void)showWaitingPanel:(NSMutableArray *)array{
    bubbleCanUse = NO;
    arrayReceiveDrivers = array;
    [self showRequestView:YES];
    [self showCancelBtn:YES];
    
    waitingRequestView.labelCount.text = [NSString stringWithFormat:@"共有%d辆出租车收到消息",array.count];
    [self performSelector:@selector(getMyTripConversations) withObject:nil afterDelay:CONVERSATION_REFRESH_TIME];
}

- (void)showAnswerCar{
    [self showDriverContent:YES];
    imgNote.hidden = YES;
}

- (void)showProfile{
    FCSettingsViewController *settings = [[FCSettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

#pragma mark
#pragma mark - update conversations

- (void)updateConversations:(int)type andReason:(NSString *)reason{
    [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(getMyTripConversations) object:nil];
    bubbleCanUse = YES;
    if (!conversationRequest) {
        [self createConversationRequest];
    }
    [conversationRequest updateConversation:converID status:type andCancelReason:reason];
}

- (void)createConversationRequest{
    conversationRequest = [[FCConversationRequest alloc] init];
    [conversationRequest setDelegate:self];
}

//获取司机应答信息 每十秒获取一次
- (void)getMyTripConversations{
    [self performSelector:@selector(getMyTripConversations) withObject:nil afterDelay:CONVERSATION_REFRESH_TIME];
    
    if (!conversationRequest) {
        [self createConversationRequest];
    }
    conversationRequest.passenger = passenger;
    [conversationRequest getConversation:converID];
}

/* 获取回话成功 获取应答的司机信息 */
- (void)getConversationFinished:(NSMutableArray *)array{
    if (array.count==0) {
        return;
    }
    Conversation *conversation = [array lastObject];
    converID = conversation._id;
    if (conversation.status.intValue == 1) {
        [self showAnswerCar];
        [self showCancelBtn:YES];
        [self showRequestView:NO];
        imgNote.hidden = YES;
//        [self showCallBtn:NO];//显示“取消上车” “已经上车”
        
        for (int i = 0; i < arrayReceiveDrivers.count; i++) {
            Driver *dri = [arrayReceiveDrivers objectAtIndex:i];
            if (dri.uid.intValue == [conversation.to intValue]) {
                [self showDriverInfo:dri];
                _answerDriver = dri;
                [self showAllAnnotation:NO];
                break;
            }
            
        }
    }
}

- (void)queryCFinished:(NSMutableDictionary *)dict{
    NSLog(@"%@",dict);
}

/*
 
 司机应答时 控制显示全部标注点 和 只显示应答司机标注点的切换
 
 */
- (void)showAllAnnotation:(BOOL)show
{
    if (show) {
        [self showLocation];
        [self getDrivers];
//        [self adUserAnnotation];
//        [self addDriverLocation];
    }else{
        [myMapView removeAnnotation:_userAnnotation];
        [myMapView removeAnnotations:arrayAnn];
        for (int i = 0; i < arrayDrivers.count; i++) {
            Driver *driver = [arrayDrivers objectAtIndex:i];
            
            if ([driver.car_license isEqual:_answerDriver.car_license]) {
                FCDriverAnnotation* annotation = [[FCDriverAnnotation alloc]initWithLatitude:driver.lat.floatValue longitude:driver.lng.floatValue];
                annotation.driver = driver;
                [myMapView addAnnotation:annotation];
                
                [self setMapCenter:driver.lat.floatValue andLng:driver.lng.floatValue];
                
                [NSThread cancelPreviousPerformRequestsWithTarget:self selector:@selector(getDrivers) object:nil];
                break;
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
