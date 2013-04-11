//
//  MyOrderViewController.h
//  FindCab
//
//  Created by paopao on 13-4-11.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCBaseViewController.h"
#import "MyOrderCell.h"
#import "FCOrderDetailViewController.h"

@interface MyOrderViewController : FCBaseViewController<UITableViewDataSource,UITableViewDelegate>

/*
 
 正在进行中的订单
 
 */
@property(nonatomic, strong) UITableView *ongoingTableView;

/*
 
 已经完成的订单
 
 */
@property(nonatomic, strong) UITableView *pastOrderTableView;
@end
