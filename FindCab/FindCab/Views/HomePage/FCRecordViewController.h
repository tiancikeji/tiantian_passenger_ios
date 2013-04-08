//
//  FCRecordViewController.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
//#import "iflyMSC/SpeechUser.h"
//#import "iflyMSC/UpLoadController.h"
//#import "iflyMSC/IFlyRecognizeControl.h"
//#import "iFlyMSC/IFlySynthesizerControl.h"
#import "FCConversationRequest.h"
#import "FCInputLocationViewController.h"
#import "AddressInfo.h"

@interface FCRecordViewController : FCBaseViewController<FCInputLocationViewControllerDelegate>{
    
//    IFlyRecognizeControl		*_iFlyRecognizeControl;         //识别控件,recognizer
//    AVAudioRecorder *recorder;
//    NSURL *recordedTmpFile;
    
//    UIButton *btnFly;
    
    UIButton *textStart,*textEnd;
    UIButton *btnClear;
    UIImageView *imgLocation;
    
    id mainContent;
    FCConversationRequest *conversationRequest;
    BOOL isUserLocation;
//    NSError *error;
}
@property (nonatomic, strong) Passenger *passenger;
@property (nonatomic) CLLocationCoordinate2D coorUser;
@property (nonatomic) CLLocationCoordinate2D endLocation;
@property (nonatomic) CLLocationCoordinate2D startLocation;
@property (nonatomic, strong) UIButton *price1;
@property (nonatomic, strong) UIButton *price2;
@property (nonatomic, strong) UIButton *price3;
@property (nonatomic, strong) UIButton *price4;
@property (nonatomic, strong) UIButton *price5;
@property (nonatomic) int price;

/*
  存储用户输入的地点和终点信息
 */
@property (nonatomic, strong) NSString *myLocationName;

@end
