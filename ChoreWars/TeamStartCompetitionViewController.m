//
//  TeamStartCompetitionViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/28/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamStartCompetitionViewController.h"

@interface TeamStartCompetitionViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *completionDate;
@end

@implementation TeamStartCompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectDate:(UIDatePicker *)sender {
    self.completionDate = self.datePicker.date;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
