//
//  FCInputLocationViewController.m
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCInputLocationViewController.h"

static NSString *const STCellIdentifier = @"STCell";

@interface FCInputLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FCSTView *_customView;
    NSArray *_datasource;
    BMKMapView *_map;
}
@end

@implementation FCInputLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil starting:(BOOL)starting
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.navigationBarHidden  =YES;
        self.starting = starting;
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"allBg.png"]]];
        //        [[self navigationItem] setTitle:@"Search Display Controller!"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [paths objectAtIndex:0];
        historyFile = [docPath stringByAppendingPathComponent:@"history.plist"];
        _datasource = [[NSArray alloc] initWithContentsOfFile:historyFile];
//        _datasource = @[@"Apple", @"Banana", @"Orange", @"Grape"];
//        _searchDatasource = n
    }
    return self;
}

- (void)loadView
{
    FCSTView *view = [[FCSTView alloc] initWithFrame:[[UIScreen mainScreen] bounds] Starting:self.starting];
    _customView = view;
    [_customView setDelegate:self];
    [self setView:view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_customView.searchField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _map = [[BMKMapView alloc] init];
//    [_map setDelegate:self];
//    [_map setShowsUserLocation:YES];
    
    _search = [[BMKSearch alloc] init];
    [_search setDelegate:self];
    [BMKSearch setPageCapacity:9];
    
    _userLocation = _map.userLocation.coordinate;
    NSLog(@"%f,%f",_userLocation.latitude,_userLocation.longitude);

    [[_customView tableView] setDelegate:self];
    [[_customView tableView] setDataSource:self];
    
    _searchDatasource = [NSMutableArray arrayWithCapacity:6];
//    if ([[_customView tableView] respondsToSelector:@selector(registerClass:forCellReuseIdentifier:)]) {
//        [[_customView tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:STCellIdentifier];
//    }
	// Do any additional setup after loading the view.
}

#pragma mark 
#pragma mark BMKMapViewDelegate Methods
//
//- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
//{
//    _userLocation = mapView.userLocation.coordinate;
//    NSLog(@"%f,%f",_userLocation.latitude,_userLocation.longitude);
//
//}
//
//- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
//{
//    _userLocation = userLocation.coordinate;
//    NSLog(@"%f,%f",_userLocation.latitude,_userLocation.longitude);
//}
//
//-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
//    
//    NSLog(@"定位错误%@",error);
//}

#pragma mark - STViewDelegate Methods

- (void)cancelClicked
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loadAddress:(NSString *)searchLocation
{
    NSLog(@"%f,%f",self.coorUser.latitude,self.coorUser.longitude);
    [_search poiSearchNearBy:searchLocation center:self.coorUser radius:100000 pageIndex:0];
}

#pragma mark
#pragma mark BMKSearchDelegate Methods

- (void)onGetPoiResult:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error
{
    if (error == BMKErrorOk) {
        [_searchDatasource removeAllObjects];
        BMKPoiResult *result = [poiResultList objectAtIndex:0];
        for (int i = 0; i<result.poiInfoList.count; i++) {
            BMKPoiInfo *poi = [result.poiInfoList objectAtIndex:i];
            AddressInfo *info = [[AddressInfo alloc] init];
            info.placeName = poi.name;
            info.detailAddress = poi.address;
            info.location = poi.pt;
            
            NSLog(@"%@,%@",poi.name,poi.address);
            [_searchDatasource addObject:info];
        }
    }
    [_customView.tableView reloadData];
}

#pragma mark
#pragma mark - UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *datasouce = [tableView isEqual:[_customView tableView]] ? _datasource : _searchDatasource;
  NSArray *  datasouce = (![_searchDatasource count])?_datasource:_searchDatasource;
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:STCellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBgTop.png"]];
    }else if(indexPath.row == 9)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBgLow.png"]];
    }else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]];
    }
    
    if ([_searchDatasource count]<=indexPath.row) {
        
    }else{
        if ([_searchDatasource count]>0) {
            AddressInfo *info = [_searchDatasource objectAtIndex:indexPath.row];
            [cell.textLabel setText:info.placeName];
            [cell.detailTextLabel setText:info.detailAddress];
        }else{
            AddressInfo *info = [_historyArray objectAtIndex:indexPath.row];
            [[cell textLabel] setText:info.placeName];
            [cell.detailTextLabel setText:info.detailAddress];
        }
        if (indexPath.row>=10) {
            return nil;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_searchDatasource count]<=indexPath.row) {
        
    }else{
        AddressInfo *info = [_searchDatasource objectAtIndex:indexPath.row];
        NSString *selectedPlace = info.placeName;
        
        if ([self.delegate respondsToSelector:@selector(inputLocationViewController:selectedLocation:andLocation:starting:)]) {
            [_delegate inputLocationViewController:self selectedLocation:selectedPlace andLocation:info.location starting:self.starting];
        }
        
        if (_historyArray) {
            if ([_historyArray count]==10) {
                [_historyArray removeLastObject];
            }
            
            [_historyArray addObject:info];
            
            [_historyArray writeToFile:historyFile atomically:YES];
        }else{
            _historyArray = [NSMutableArray arrayWithCapacity:10];
            //操作完若修改了数据则，写入文件
            [_historyArray addObject:info];
            [_historyArray writeToFile:historyFile atomically:YES];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark
#pragma mark

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_customView.searchField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
