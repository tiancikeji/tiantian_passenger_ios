//
//  MyOrderDetail.h
//  FindCab
//
//  Created by paopao on 13-4-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderDetail : NSObject

@property(nonatomic, strong) NSString *driverName;
@property(nonatomic, strong) NSString *car_license;
@property(nonatomic, strong) NSString *starting;
@property(nonatomic, strong) NSString *ending;
@property(nonatomic, strong) NSDate *orderDate;
@property(nonatomic) CGFloat distance;
@property(nonatomic) CGFloat money;
@property(nonatomic) BOOL answerStatus;
@property(nonatomic, strong) NSString *car_service_number;

@end
