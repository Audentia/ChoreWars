//
//  ViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ViewController.h"
#import "ChoreView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect choreSize = CGRectMake(self.view.frame.size.width / 2 - 50, self.view.frame.size.height / 2 - 50, 100, 100);
    ChoreView *choreOne = [[ChoreView alloc] initWithFrame:choreSize];
    ChoreView *choreTwo = [[ChoreView alloc] initWithFrame:choreSize];
    choreTwo.backgroundColor = [UIColor redColor];
    [self.view addSubview:choreOne];
    [self.view addSubview:choreTwo];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
