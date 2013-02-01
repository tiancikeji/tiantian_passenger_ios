//
//  FCDriverAnnotationView.m
//  FindCab
//
//  Created by leon on 13-1-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCDriverAnnotationView.h"

@implementation FCDriverAnnotationView

NSString* const AnnotationReuseIdentifier1 = @"AnnotationReuse";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (FCDriverAnnotationView *)tripAnnotationView:(NSObject <BMKAnnotation> *)annotation{
    return [[FCDriverAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationReuseIdentifier1];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"dfffgggggg");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
