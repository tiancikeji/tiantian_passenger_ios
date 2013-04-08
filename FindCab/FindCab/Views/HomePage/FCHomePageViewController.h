//
//  FCHomePageViewController.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "Driver.h"
#import "BMapKit.h"
#import "FCDriverInfoView.h"
#import "FCWaitingRequestView.h"
#import "FCServiceResponse.h"
#import "CancelView.h"
#import "UserAnnotation.h"
#import "CancelReasonView.h"
//#import "FCRecordViewController.h"

@class FCConversationRequest;

enum ConversationType{
    ConversationTypeRefuse = -1,
    ConversationTypeNew,
    ConversationTypeAccept = 3,
};

@interface FCHomePageViewController : FCBaseViewController<BMKMapViewDelegate,CLLocationManagerDelegate,FCServiceResponseDelegate,CancelViewDelegate,FCWaitingRequestViewDelegate,CancelReasonViewDelegate>{
    BMKMapView *myMapView;
    NSMutableArray *arrayDrivers;//司机信息
    NSMutableArray *arrayAnn;
    UIView *viDriverInfo;
    UILabel *labelCarLicense,*labelMobile,*labelName,*labelRate,*labelSearchCount;
    UIImageView *imgNote,*imgToolbar;
    UIButton *btnCall,*btnCancel,*btnOnCar,*btnCancelRequest;
    FCDriverInfoView *driverInfoView;
    FCWaitingRequestView *waitingRequestView;
    FCConversationRequest *conversationRequest;
    CLLocationManager *locationManager;//用户定位管理器
    
    BOOL bubbleCanUse;
    BMKCoordinateRegion newRegion;//存储当前用户位置及5公司范围
    BMKCoordinateRegion userRegion;//存储当前地图的显示范围
    NSString *myCityName;
    NSString *myDetailAddress;
    NSString *myLocationName;
    NSString *mySubAddress;
}

@property(nonatomic,strong) CancelReasonView *reasonView;
@property (nonatomic, strong) BMKPointAnnotation *userAnnotation;
@property (nonatomic, strong) NSNumber *converID,*tripID;
@property (nonatomic, strong) Passenger *passenger;
@property (nonatomic, strong) NSMutableArray *arrayReceiveDrivers;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) CancelView *cancelView;
@property (nonatomic, strong) NSString *myLocation;
@property (nonatomic, strong) Driver *answerDriver;
@property (nonatomic) CLLocationCoordinate2D coorUser;//用户位置
//@property (nonatomic, strong) FCBaseViewController *recordController;



/*
 
 显示用户等待应答状态栏，开始创建与司机端对话
 
 */
- (void)showWaitingPanel:(NSMutableArray *)array;

/*
 
 添加用户位置标注点
 
 */
- (void)adUserAnnotation;

/*
 
 司机应答时 控制显示全部标注点 和 只显示应答司机标注点的切换
 
 */
- (void)showAllAnnotation:(BOOL)show;//接收司机响应后，只显示当前接收响应的司机位置 其他标注点移除


- (void)setMapCenter:(CLLocationDegrees)lat andLng:(CLLocationDegrees)lng;//设置地图中心位置

@end
