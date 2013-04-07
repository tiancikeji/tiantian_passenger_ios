//
//  FCInputLocationViewController.m
//  FindCab
//
//  Created by paopao on 13-3-27.
//  Copyright (c) 2013年 Tiantian. All rights reserved.
//

#import "FCInputLocationViewController.h"

#define listNumber 9
static NSString *const STCellIdentifier = @"STCell";

@interface FCInputLocationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    FCSTView *_customView;
    NSMutableArray *_datasource;
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
    }
    return self;
}

- (void)loadView
{
    FCSTView *view = [[FCSTView alloc] initWithFrame:[[UIScreen mainScreen] bounds] Starting:self.starting];
    _customView = view;
    [_customView setDelegate:self];
    [self setView:view];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    historyFile = [docPath stringByAppendingPathComponent:@"history.plist"];
    NSArray *history = [[NSArray alloc] initWithContentsOfFile:historyFile];
    _historyArray = [NSMutableArray arrayWithCapacity:10];
    
    //起点 列表默认第一行是我的位置 
    if (_starting) {
        AddressInfo *info = [[AddressInfo alloc] init];
        info.placeName = @"我的位置";
        info.location = _userLocation;
        [_historyArray addObject:info];
    }
    
    for (int i = 0; i<history.count; i++) {
        NSMutableDictionary *dic = [history objectAtIndex:i];
        AddressInfo *info = [[AddressInfo alloc] init];
        info.placeName = [dic valueForKey:@"placeName"];
        info.detailAddress = [dic valueForKey:@"detailAddress"];
        CLLocationCoordinate2D location;
        location.latitude = [[dic valueForKey:@"latitude"]doubleValue];
        location.longitude = [[dic valueForKey:@"longitude"]doubleValue];
        NSLog(@"%@,%@,%f,%f",[dic valueForKey:@"placeName"],[dic valueForKey:@"detailAddress"],[[dic valueForKey:@"latitude"]doubleValue],[[dic valueForKey:@"longitude"]doubleValue]);
        info.location = location;
        [_historyArray addObject:info];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_customView.searchField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return listNumber;
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
    }else if(indexPath.row == listNumber-1)
    {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBgLow.png"]];
    }else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]];
    }

    if ([_searchDatasource count]>0) {
        if ([_searchDatasource count]<=indexPath.row) {
            [cell.textLabel setText:@""];
            [cell.detailTextLabel setText:@""];
        }else{
            AddressInfo *info = [_searchDatasource objectAtIndex:indexPath.row];
            [cell.textLabel setText:info.placeName];
            [cell.detailTextLabel setText:info.detailAddress];
        }
    }else{
        if ([_historyArray count]<= indexPath.row) {
            [cell.textLabel setText:@""];
            [cell.detailTextLabel setText:@""];
        }else{
            AddressInfo *info = [_historyArray objectAtIndex:indexPath.row];
            [[cell textLabel] setText:info.placeName];
            [cell.detailTextLabel setText:info.detailAddress];
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
    AddressInfo *info;
    if ([_searchDatasource count] && [_searchDatasource count]>indexPath.row) {
        info = [_searchDatasource objectAtIndex:indexPath.row];
    }else if([_historyArray count]>indexPath.row){
        info = [_historyArray objectAtIndex:indexPath.row];
    }
    if (info) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:info.placeName,@"placeName",info.detailAddress,@"detailAddress",[NSString stringWithFormat:@"%f",info.location.latitude],@"latitude",[NSString stringWithFormat:@"%f",info.location.longitude],@"longitude", nil];
        
        NSString *selectedPlace = info.placeName;
        if ([self.delegate respondsToSelector:@selector(inputLocationViewController:selectedLocation:andLocation:starting:)]) {
            [_delegate inputLocationViewController:self selectedLocation:selectedPlace andLocation:info.location starting:self.starting];
        }
        if ([info.placeName isEqualToString:@"我的位置"]) {
            
        }else{
            NSMutableArray *history = [[NSMutableArray alloc] initWithContentsOfFile:historyFile];
            if (history) {
                if (![history containsObject:dic]) {
                    if ([history count]==listNumber) {
                        [history removeLastObject];
                    }
                    [history insertObject:dic atIndex:0];
                    [history writeToFile:historyFile atomically:YES];
                }
            }else{
                history = [NSMutableArray arrayWithCapacity:10];
                //操作完若修改了数据则，写入文件
                [history addObject:dic];
                [history writeToFile:historyFile atomically:YES];
            }
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark
#pragma mark

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_customView.searchField isFirstResponder]) {
        [_customView.searchField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
