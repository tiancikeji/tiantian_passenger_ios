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
    _lightImageView = [[UIImageView alloc] initWithImage:loading];
    _lightImageView.frame = CGRectMake(0, 0, loading.size.width, loading.size.height);
    _lightImageView.center = CGPointMake(25, self.frame.size.height/2.0);
     
    [self addSubview:_lightImageView];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, loading.size.height-10)];
    [_time setCenter:CGPointMake(29, _lightImageView.center.y)];
    [_time setBackgroundColor:[UIColor clearColor]];
    [_time setTextColor:[UIColor whiteColor]];
    [_time setText:@"90"];
    [_time setFont:[UIFont boldSystemFontOfSize:15]];
    [self addSubview:_time];
    timeDown = 90;
    lightTimeDown = 10000;
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    [self startRotate];
    
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
    if (timeDown == 0) {
        [timer invalidate];
        [_delegate countDownEnding];
    }
}

- (void)updateStatus{
    timeDown = 90;
    [_time setText:[NSString stringWithFormat:@"%d",timeDown]];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(count:)
                                   userInfo:nil
                                    repeats:YES];
    [self startRotate];
}


- (void)startRotate

{
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(rotateGraduation)
                                                      userInfo:nil
                                                       repeats:YES];
}

//关闭定时器
- (void)stopTimer

{
    if ([self.rotateTimer isValid])
    {
        [self.rotateTimer invalidate];
        self.rotateTimer = nil;
        lightTimeDown = 10000;
    }
    
}



//旋转动画
- (void)rotateGraduation

{
    lightTimeDown--;
    if (lightTimeDown == 0)
    {
        [self stopTimer];
        // doSomeThing //旋转完毕 可以干点别的
        lightTimeDown = 10000;
    }else{
        //计算角度 旋转
        static CGFloat radian = 150 * (M_2_PI / 360);
        CGAffineTransform transformTmp = self.lightImageView.transform;
        transformTmp = CGAffineTransformRotate(transformTmp, radian);
        self.lightImageView.transform = transformTmp;
    };
    
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
