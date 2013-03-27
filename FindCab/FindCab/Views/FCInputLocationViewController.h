//
//  FCInputLocationViewController.h
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSTView.h"
#import "Passenger.h"

@interface FCInputLocationViewController : UIViewController<FCSTViewDelegate>
{
    UIImageView *myPosition;
}
@property (nonatomic) BOOL starting;
@property (nonatomic, strong) Passenger *passenger;

@end
