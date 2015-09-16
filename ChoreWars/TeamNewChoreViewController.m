//
//  TeamNewChoreViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/28/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamNewChoreViewController.h"
#import "Chore.h"

@interface TeamNewChoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation TeamNewChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated {
    [[CoreDataManager sharedInstance] saveChore:self.detailItem WithName:self.nameTextField.text];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
