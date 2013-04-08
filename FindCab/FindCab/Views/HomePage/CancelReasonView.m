//
//  CancelReasonView.m
//  FindCab
//
//  Created by paopao on 13-4-1.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "CancelReasonView.h"

#define REASONTAG 3000

@implementation CancelReasonView

- (id)initWithFrame:(CGRect)frame
{
    UIImage *reasonBg = [UIImage imageNamed:@"reasonBg.png"];
    frame.size = reasonBg.size;
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:reasonBg]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        [label setCenter:CGPointMake(frame.size.width/2, frame.size.height/8*1)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:@"请选择取消叫车的原因"];
        [label setTextColor:[UIColor whiteColor]];
        [self addSubview:label];
        
        UIImage *buttonBg = [UIImage imageNamed:@"stillTaxi.png"];
        UIImage *buttonBgA = [UIImage imageNamed:@"stillTaxiA.png"];
        for (int i = 0; i<4; i++) {
            UIButton *reason = [UIButton buttonWithType:UIButtonTypeCustom];
            [reason setBackgroundImage:buttonBg forState:UIControlStateNormal];
            [reason.titleLabel setTextColor:[UIColor whiteColor]];
            [reason.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
            switch (i) {
                case 0:
                    [reason setTitle:@"已选择其他交通方式" forState:UIControlStateNormal];
                    break;
                case 1:
                    [reason setTitle:@"已经在路上打到车了" forState:UIControlStateNormal];
                    break;
                case 2:
                    [reason setTitle:@"等待时间太长" forState:UIControlStateNormal];
                    break;
                case 3:
                    [reason setTitle:@"其他" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [reason setBackgroundImage:buttonBgA forState:UIControlStateHighlighted];
            [reason setFrame:CGRectMake(0, 0, buttonBg.size.width, buttonBg.size.height)];
            [reason setCenter:CGPointMake(frame.size.width/2, frame.size.height/6*(i+1)+30+5*(i+1))];
            [reason setTag:(i+REASONTAG)];
            [reason addTarget:self action:@selector(chooseReason:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:reason];
        }
    }
    return self;
}

- (void)chooseReason:(UIButton *)sender
{
    [_delegate clickReason:sender];
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
