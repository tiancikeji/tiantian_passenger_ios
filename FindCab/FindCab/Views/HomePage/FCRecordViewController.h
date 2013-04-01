//
//  FCRecordViewController.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "iflyMSC/SpeechUser.h"
#import "iflyMSC/UpLoadController.h"
#import "iflyMSC/IFlyRecognizeControl.h"
#import "iFlyMSC/IFlySynthesizerControl.h"
#import "FCConversationRequest.h"
#import "FCInputLocationViewController.h"
#import "AddressInfo.h"

@interface FCRecordViewController : FCBaseViewController<AVAudioRecorderDelegate,UpLoadControllerDelegate,IFlyRecognizeControlDelegate,IFlyRecognizeControlDelegate, FCInputLocationViewControllerDelegate>{
    
    IFlyRecognizeControl		*_iFlyRecognizeControl;         //识别控件,recognizer
    AVAudioRecorder *recorder;
    NSURL *recordedTmpFile;
    
    UIButton *btnFly;
    
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

/*
  存储用户输入的地点和终点信息
 */
@property (nonatomic, strong) AddressInfo *starting;
@property (nonatomic, strong) AddressInfo *ending;

@end
