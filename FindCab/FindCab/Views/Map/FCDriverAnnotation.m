//
//  FCDriverAnnotation.m
//  FindCab
//
//  Created by leon on 13-1-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCDriverAnnotation.h"

@implementation FCDriverAnnotation

@synthesize driver;

- (id)initWithLatitude:(CLLocationDegrees)theLatitude longitude:(CLLocationDegrees)theLongitude {
	if (!(self = [super init])) {
		return nil;
	}
	
	latitude = theLatitude;
	longitude = theLongitude;
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	return (CLLocationCoordinate2D){latitude, longitude};
}

//- (CLLocationCoordinate2D)coordinate;
//{
//    CLLocationCoordinate2D theCoordinate;
//    theCoordinate.latitude = latitude.floatValue;
//    theCoordinate.longitude = longitude.floatValue;
////    theCoordinate.latitude = 39.915;
////    theCoordinate.longitude = 116.404;
//    return theCoordinate;
//}

//- (NSString *)title
//{
//    return @" ";
//}

@end
