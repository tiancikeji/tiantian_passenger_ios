//
//  SearchBarView.m
//  FindCab
//
//  Created by paopao on 13-3-26.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"nav_bar"];
        [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
        [self setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    }
    return self;
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
