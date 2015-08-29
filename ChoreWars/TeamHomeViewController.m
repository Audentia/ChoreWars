//
//  ViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamHomeViewController.h"
#import "ChoreView.h"

@interface TeamHomeViewController ()

@end

@implementation TeamHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 }
- (IBAction)didPressLogoutButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
