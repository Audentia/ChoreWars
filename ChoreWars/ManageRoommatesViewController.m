//
//  AddRoommatesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageRoommatesViewController.h"
#import "TeamView.h"
#import "RoommateView.h"
#import "CoreDataManager.h"
#import "Roommate.h"

@interface ManageRoommatesViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedRoommates;

@end

@implementation ManageRoommatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Roommate" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
       self.fetchedRoommates = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.fetchedRoommates performFetch:nil];
    
    for (Roommate *roommate in self.fetchedRoommates.fetchedObjects) {
        RoommateView *newRoommate = [[RoommateView alloc] initWithFrame:CGRectMake(1, 1, 10, 10)];
        newRoommate.roommate = roommate;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
