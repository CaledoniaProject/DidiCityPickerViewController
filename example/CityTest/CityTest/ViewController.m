//
//  ViewController.m
//  CityTest
//
//  Created by Aaron on 8/3/16.
//  Copyright © 2016 whatever. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityButton.layer.cornerRadius = 4;
    self.cityButton.layer.borderColor = [UIColor colorWithRed:0.24 green:0.60 blue:1.00 alpha:1.00].CGColor;
    self.cityButton.layer.borderWidth = 1;
}

- (IBAction)didTapCityButton:(id)sender {
    CityPickerViewController *vc = [[CityPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPickCity:(NSString *)cityName
{
    self.cityLabel.text = cityName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
