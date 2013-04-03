//
//  UserAnnotation.m
//  FindCab
//
//  Created by paopao on 13-4-2.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
andLongitude:(CLLocationDegrees)longitude andTitle:(NSString *)title {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.title = title;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end
