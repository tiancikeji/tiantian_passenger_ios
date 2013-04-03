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
    imgBg.image = [UIImage imageNamed:@"waiting_request_bg.png"];
    [self addSubview:imgBg];
    
    UIImage *loading = [UIImage imageNamed:@"loading.png"];
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
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, 20, loading.size.height-10)];
    [_time setBackgroundColor:[UIColor clearColor]];
    [_time setTextColor:[UIColor whiteColor]];
    [_time setText:@"60"];
    [_time setFont:[UIFont boldSystemFontOfSize:15]];
    [imgLoading addSubview:_time];
    timeDown = 60;

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(54, 13+23*i, 200, 15)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        if (i == 0) {
            labelCount = label;
            label.text = @"共有0辆出租车收到消息";
        }
        else {
            label.text = @"请等待司机应答⋯⋯";
        }
        [self addSubview:label];
    }

	//[imgLoading addAnimation:rotationAnimation forKey:@"rotateAnimation"];
}

- (void)count:(NSTimer *)timer
{
    [_time setText:[NSString stringWithFormat:@"%d",--timeDown]];
    if (self.hidden == YES || timeDown == 0) {
        [timer invalidate];
        [_time setText:@"60"];
    }
}

- (void)updateStatus{
    timeDown = 60;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(count:) userInfo:nil repeats:YES];
    [imgLoading.layer animationForKey:@"rotateAnimation"];
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
