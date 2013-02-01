//
//  FCDriverAnnotationView.h
//  FindCab
//
//  Created by leon on 13-1-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "BMKAnnotationView.h"

//NSString* const AnnotationReuseIdentifier = @"AnnotationReuse";

@interface FCDriverAnnotationView : BMKAnnotationView

+ (FCDriverAnnotationView *)tripAnnotationView:(NSObject <BMKAnnotation> *)annotation;
@end
