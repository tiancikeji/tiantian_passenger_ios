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
#import "FCAppointViewController.h"
#import "FMDatabase.h"
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
    NSMutableArray *arrayAnn;//所有司机标注点
    UILabel *labelSearchCount;//显示附近有几个司机
    UIImageView *imgNote,*imgToolbar;
    UIButton *btnCall,*btnCancel,*btnOnCar,*btnCancelRequest;
    FCDriverInfoView *driverInfoView;//司机信息状态栏
    FCWaitingRequestView *waitingRequestView;//等待应答状态栏
    FCConversationRequest *conversationRequest;//对话请求
    CLLocationManager *locationManager;//用户定位管理器
    
    BOOL bubbleCanUse;//是否可弹出司机气泡 暂不用 确定后可删除该参数
    
    BMKCoordinateRegion newRegion;//存储当前用户位置及5公司范围
    BMKCoordinateRegion userRegion;//存储当前地图的显示范围
    NSString *myCityName;//城市名称
    NSString *myDetailAddress;//详细地质
    NSString *myLocationName;
    NSString *mySubAddress;
}

/*
 用户选择取消叫车原因的View
 */
@property(nonatomic,strong) CancelReasonView *reasonView;

/*
 用户标注
 */
@property (nonatomic, strong) BMKPointAnnotation *userAnnotation;

/*
  converID:和司机会话的ID
 
 */
@property (nonatomic, strong) NSNumber *converID,*tripID;

/*
  用户信息
 */
@property (nonatomic, strong) Passenger *passenger;

/*
 
 存储接收到打车请求的司机信息
 
 */
@property (nonatomic, strong) NSMutableArray *arrayReceiveDrivers;

/*
 
 取消叫车弹出的半透明背景
 
 */
@property (nonatomic, strong) UIView *translucentView;

/*
 
 取消叫车后弹出的是否确定取消界面
 
 */
@property (nonatomic, strong) CancelView *cancelView;

/*
 
 当前用户位置的街道信息
 
 */
@property (nonatomic, strong) NSString *myLocation;

/*
 
 当前应答的司机信息
 
 */
@property (nonatomic, strong) Driver *answerDriver;

/*
 
 用户位置的坐标
 
 */
@property (nonatomic) CLLocationCoordinate2D coorUser;

/*
 
 预约叫车按钮
 
 */
@property(nonatomic,strong) UIButton *appointCallBtn;
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
