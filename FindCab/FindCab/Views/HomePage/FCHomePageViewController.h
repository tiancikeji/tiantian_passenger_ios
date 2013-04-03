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

@class FCConversationRequest;

enum ConversationType{
    ConversationTypeRefuse = -1,
    ConversationTypeNew,
    ConversationTypeAccept = 3,
};

@interface FCHomePageViewController : FCBaseViewController<BMKMapViewDelegate,CLLocationManagerDelegate,FCServiceResponseDelegate,CancelViewDelegate>{
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
    CLLocationCoordinate2D coorUser;//用户位置
    
    BOOL bubbleCanUse;
    BMKCoordinateRegion newRegion;//存储当前用户位置及5公司范围
    BMKCoordinateRegion userRegion;//存储当前地图的显示范围
    NSString *myCityName;
    NSString *myDetailAddress;
    NSString *myLocationName;
    NSString *mySubAddress;
}

@property (nonatomic, strong) BMKPointAnnotation *userAnnotation;
@property (nonatomic, strong) NSNumber *converID,*tripID;
@property (nonatomic, strong) Passenger *passenger;
@property (nonatomic, strong) NSMutableArray *arrayReceiveDrivers;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) CancelView *cancelView;
@property (nonatomic, strong) NSString *myLocation;

- (void)showWaitingPanel:(NSMutableArray *)array;
- (void)adUserAnnotation;

@end
