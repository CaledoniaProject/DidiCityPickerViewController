//
//  CityPickerViewController.m
//
//  Created by Aaron on 6/21/16.
//  Copyright © 2016 whatever. All rights reserved.
//

#import "CityPickerViewController.h"

@implementation CityPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self setupNav];
    [self setupTextField];
    [self setupLocation];
}

- (void)setupLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate        = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter  = 1000.0f;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textField resignFirstResponder];
}

- (void)setupTextField
{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 40)];
    _textField.textColor = [UIColor whiteColor];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = @"输入城市名过滤";
    [_textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.navigationItem.titleView = _textField;
}

- (void)setupTableView
{
    _indices = [CityModel indices];
    _grouped = [CityModel grouped];
    _all     = [CityModel all];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

- (void)setupNav
{
    self.title = @"";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightItemTapped:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:15] }
                                                          forState:UIControlStateNormal];
}

#pragma mark -- text field

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text length])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"pinyin contains[c] '%@' or name contains[c] '%@' or shortname contains[c] '%@'", textField.text, textField.text, textField.text]];
        _filtered = [_all filteredArrayUsingPredicate:predicate];
    }
    
    [_tableView reloadData];
}

#pragma mark -- loc

- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if ([placemarks count] != 1) {
                           return;
                       }
                       
                       CLPlacemark *place = [placemarks objectAtIndex:0];
                       _currentCity = [place.addressDictionary valueForKey:@"City"];
                       [_tableView reloadData];
                   }];
}

#pragma mark -- nav

- (void)rightItemTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftItemTapped:(id)sender
{
    
}

#pragma mark -- scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}

#pragma mark -- table

- (BOOL)isSearching
{
    return [self.textField.text length];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([self isSearching])
    {
        return nil;
    }
    
    return _indices;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didPickCity:)])
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (! [self isSearching] && indexPath.row == 0 && indexPath.section == 0)
        {
            [self.delegate didPickCity:_currentCity];
        }
        else
        {
            [self.delegate didPickCity:cell.textLabel.text];
        }
        
        [self rightItemTapped:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont systemFontOfSize:15];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indices[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self isSearching])
    {
        return 0;
    }
    
    if (section == 0)
    {
        return 0;
    }
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self isSearching])
    {
        return 1;
    }
    
    return [_grouped count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self isSearching])
    {
        return [_filtered count];
    }
    
    return [_grouped[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 搜索时显示搜索结果
    if ([self isSearching])
    {
        CityModel *city = _filtered[indexPath.row];
        cell.textLabel.text = city.name;
        return cell;
    }
    
    if (indexPath.section == 0)
    {
        if (_currentCity == nil)
        {
            cell.textLabel.text = @"定位中 ...";
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"当前定位城市: %@", _currentCity];
        }
    }
    else
    {
        CityModel *city = [[_grouped objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
    }
    
    return cell;
}

@end
