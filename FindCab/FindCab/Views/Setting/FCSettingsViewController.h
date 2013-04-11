//
//  FCSettingsViewController.h
//  FindCab
//
//  Created by paopao on 13-4-8.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "MyOrderViewController.h"


@interface FCSettingsViewController : FCBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *updateTableView;
@property(nonatomic, strong) UITableView *myOrderTableView;
@property(nonatomic, strong) UITableView *aboutTableView;

@end
