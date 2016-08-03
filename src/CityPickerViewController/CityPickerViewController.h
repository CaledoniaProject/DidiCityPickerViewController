//
//  CityPickerViewController.h
//
//  Created by Aaron on 6/21/16.
//  Copyright © 2016 whatever. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "CityModel.h"

@protocol CityPickerDelegate <NSObject>

- (void)didPickCity:(NSString *)cityName;

@end

@interface CityPickerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) id<CityPickerDelegate> delegate;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSString *currentCity;

@property (strong, nonatomic) NSArray *indices, *grouped, *all, *filtered;

@end
