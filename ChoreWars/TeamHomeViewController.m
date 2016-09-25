//
//  ViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamHomeViewController.h"
#import "EntityView.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface TeamHomeViewController () <PFLogInViewControllerDelegate>

@end

@implementation TeamHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 }

- (void)presentCustomLogin {
    PFLogInViewController *login = [[PFLogInViewController alloc] init];
    login.delegate = self;
    [self presentViewController:login animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([PFUser currentUser] == nil) {
        [self presentCustomLogin];
    }
}
- (IBAction)didPressLogoutButton:(UIBarButtonItem *)sender {
    [PFUser logOut];
    [self presentCustomLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
