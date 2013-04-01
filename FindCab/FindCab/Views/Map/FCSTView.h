//
//  FCSTView.h
//  FindCab
//
//  输入查询起始地点 搜索工具栏及TableView
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCCustomToolbar.h"
#import "AddressInfo.h"

@protocol FCSTViewDelegate <NSObject>

- (void)cancelClicked;//点击取消
- (void)loadAddress:(NSString *)searchLocation;
@end

@interface FCSTView : UIView<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *myPosition;
}

@property (nonatomic,strong ,readonly) UITableView *tableView;
//@property (nonatomic,strong, readonly) UISearchBar *searchBar;
@property (nonatomic,strong) UITextField *searchField;
@property (nonatomic, unsafe_unretained) id <FCSTViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic) BOOL starting;

- (id)initWithFrame:(CGRect)frame Starting:(BOOL)starting;
-(void)addTapGuesture;
@end
