//
//  FCDriverAnnotation.h
//  FindCab
//
//  Created by leon on 13-1-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Driver.h"
#import "BMapKit.h"

@interface FCDriverAnnotation : NSObject <BMKAnnotation>{
    CLLocationDegrees latitude,longitude;
}
@property (nonatomic, strong) Driver *driver;
- (id)initWithLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude;
@end
