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
#import "InputLocationViewController.h"

@interface FCRecordViewController : FCBaseViewController<AVAudioRecorderDelegate,UpLoadControllerDelegate,IFlyRecognizeControlDelegate,IFlyRecognizeControlDelegate,UITextFieldDelegate>{
    
    IFlyRecognizeControl		*_iFlyRecognizeControl;         //识别控件,recognizer
    AVAudioRecorder *recorder;
    NSURL *recordedTmpFile;
    
    UIButton *btnFly;
    
    UITextField *textStart,*textEnd;
    UIButton *btnClear;
    UIImageView *imgLocation;
    
    id mainContent;
    
    FCConversationRequest *conversationRequest;
    
    BOOL isUserLocation;
//    NSError *error;
}
@property (nonatomic, strong) Passenger *passenger;
@property (nonatomic, assign) CLLocationCoordinate2D coorUser;

@end
