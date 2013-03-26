//
//  FCBaseViewController.h
//  FindCab
//
//  Created by leon on 13-1-4.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface FCBaseViewController : UIViewController{
    UIImageView *imgvNavBar;
    UIImageView *imgBG;
    UILabel *labelTitle;
    NSString *strNaviTitle;
    UIButton *btnNaviLeft,*btnNaviRight;
}
@property (nonatomic, strong) NSString *strNaviTitle;

- (void)goBack;
- (void)createNaviBar;
- (void)createNaviBtnLeft:(UIImage *)img title:(NSString *)strTitle;
- (void)createNaviBtnRight:(UIImage *)img title:(NSString *)strTitle;
@end
