//
//  FCWaitingRequestView.m
//  FindCab
//
//  Created by leon on 13-1-20.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCWaitingRequestView.h"

@implementation FCWaitingRequestView
@synthesize labelCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadContent{
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:self.bounds];
    imgBg.image = [UIImage imageNamed:@"waiting_requet_bg.png"];
    [self addSubview:imgBg];
    
    UIImage *loading = [UIImage imageNamed:@"loading"];
    imgLoading = [[UIImageView alloc] initWithImage:nil];
    imgLoading.frame = CGRectMake(0, 0, loading.size.width, loading.size.height);
    imgLoading.center = CGPointMake(25, self.frame.size.height/2.0);
    
    
    CALayer *logoLayer = [CALayer layer];
    logoLayer.bounds = CGRectMake(0, 0, loading.size.width, loading.size.height);
    logoLayer.position = CGPointMake(15, 15);
    logoLayer.contents = (id)loading.CGImage;
    
    
    int direction = 1;
	CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotationAnimation.toValue = [NSNumber numberWithFloat:(200 * M_PI) * direction];
	rotationAnimation.duration = 100.0f;
    rotationAnimation.repeatDuration = 99999;
	rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [logoLayer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    
    [imgLoading.layer addSublayer:logoLayer];
    
    [self addSubview:imgLoading];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(54, 13+23*i, 200, 15)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        if (i == 0) {
            labelCount = label;
            label.text = @"共有133辆出租车收到消息";
        }
        else {
            label.text = @"请等待司机应答⋯⋯";
        }
        [self addSubview:label];
    }

	//[imgLoading addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}

- (void)updateStatus{
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
