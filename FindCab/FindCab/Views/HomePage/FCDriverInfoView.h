//
//  FCDriverInfoView.h
//  FindCab
//
//  Created by leon on 13-1-18.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Driver.h"

@interface FCDriverInfoView : UIView{
    UILabel *labelUserName,*labelDesription,*labelMiles,*labelTime;
}
@property (nonatomic, strong) Driver *driverInfo;

@end
