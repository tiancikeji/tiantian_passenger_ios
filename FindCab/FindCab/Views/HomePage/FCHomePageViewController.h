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

@class FCConversationRequest;

enum ConversationType{
    ConversationTypeRefuse = -1,
    ConversationTypeNew,
    ConversationTypeAccept = 3,
};

@interface FCHomePageViewController : FCBaseViewController<BMKMapViewDelegate>{
    BMKMapView *myMapView;
    NSMutableArray *arrayDrivers;
    NSMutableArray *arrayAnn;
    UIView *viDriverInfo;
    UILabel *labelCarLicense,*labelMobile,*labelName,*labelRate,*labelSearchCount;
    UIImageView *imgNote,*imgToolbar;
    UIButton *btnCall,*btnCancel,*btnOnCar,*btnCancelRequest;
    FCDriverInfoView *driverInfoView;
    FCWaitingRequestView *waitingRequestView;
    FCConversationRequest *conversationRequest;
    
    CLLocationCoordinate2D coorUser;
    
    BOOL bubbleCanUse;
    BMKCoordinateRegion newRegion;
}
@property (nonatomic, strong) NSNumber *converID,*tripID;
@property (nonatomic, strong) Passenger *passenger;
@property (nonatomic, strong) NSMutableArray *arrayReceiveDrivers;

@end
