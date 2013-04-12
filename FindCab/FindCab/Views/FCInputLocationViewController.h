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
#import "AddressInfo.h"

@protocol  FCInputLocationViewControllerDelegate;

@interface FCInputLocationViewController : UIViewController<FCSTViewDelegate,BMKMapViewDelegate,BMKSearchDelegate,UIScrollViewDelegate>
{
    CLLocationCoordinate2D _userLocation;
    NSMutableArray *_historyArray;//存储的搜索历史记录
    NSString *historyFile;//搜索记录的plist文件
}
@property (nonatomic) BOOL starting;
@property (nonatomic, unsafe_unretained) id <FCInputLocationViewControllerDelegate>delegate;
@property (nonatomic, strong)  BMKSearch *search;
@property (nonatomic, strong)  NSMutableArray *searchDatasource;
@property (nonatomic) CLLocationCoordinate2D coorUser;
@property (nonatomic, strong)  FCSTView *customView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil starting:(BOOL)starting;

@end

@protocol FCInputLocationViewControllerDelegate <NSObject>

- (void)inputLocationViewController:(FCInputLocationViewController *)controller
                   selectedLocation:(NSString *)selectionMessage andLocation:(CLLocationCoordinate2D) location starting:(BOOL)starting;
@end

