//
//  FCInputLocationViewController.h
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCSTView.h"
#import "BMapKit.h"

@protocol  FCInputLocationViewControllerDelegate;

@interface FCInputLocationViewController : UIViewController<FCSTViewDelegate,BMKMapViewDelegate,BMKSearchDelegate>
{
    UIImageView *myPosition;
}
@property (nonatomic) BOOL starting;
@property (nonatomic, unsafe_unretained) id <FCInputLocationViewControllerDelegate>delegate;

@end

@protocol FCInputLocationViewControllerDelegate <NSObject>

- (void)inputLocationViewController:(FCInputLocationViewController *)controller
                   selectedLocation:(NSString *)selectionMessage;

@end

