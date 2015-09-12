//
//  AddRoommatesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageRoommatesViewController.h"

@interface ManageRoommatesViewController ()

@end

@implementation ManageRoommatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRoommateViewsFromFetch:[self fetchEntitiesWithName:@"Roommate" andSortKey:@"name"]];
}



- (void)createRoommateViewsFromFetch:(NSFetchedResultsController *)fetch {
    for (Roommate *eachRoommate in fetch.fetchedObjects) {
        RoommateView *roommateView = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:eachRoommate];
        [self.view addSubview:roommateView];
        [self.view bringSubviewToFront:roommateView];
        [self.entityViewsArray addObject:roommateView];
        roommateView.delegate = self;
        NSLog(@"Made a roommateView for %@", eachRoommate.name);
    }
}




- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        Roommate *aRoommate = anObject;
        RoommateView *newRoommateView = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:aRoommate];
        [self.view addSubview:newRoommateView];
        [self.view bringSubviewToFront:newRoommateView];
        [self.roommateViewsArray addObject:newRoommateView];
        newRoommateView.delegate = self;
        NSLog(@"Made a roommateView for %@", aRoommate.nameRoommate);
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
