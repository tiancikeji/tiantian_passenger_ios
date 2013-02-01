//
//  Driver.h
//  FindCab
//
//  Created by leon on 13-1-5.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "NSRRemoteObject.h"
#import "Passenger.h"

@interface Driver : Passenger

@property (nonatomic, strong) NSString *car_license,*car_type,*car_service_number,*rate;
@property (nonatomic, strong) NSNumber *status,*distance;

@end
