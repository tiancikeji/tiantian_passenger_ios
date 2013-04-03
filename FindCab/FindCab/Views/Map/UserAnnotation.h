//
//  UserAnnotation.h
//  FindCab
//
//  Created by paopao on 13-4-2.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface UserAnnotation : NSObject<BMKAnnotation>
{
    CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic,strong) NSString *title;

- (id)initWithLatitude:(CLLocationDegrees)latitude
          andLongitude:(CLLocationDegrees)longitude andTitle:(NSString *)title;
@end
