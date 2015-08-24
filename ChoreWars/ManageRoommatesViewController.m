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
#import "Roommate.h"
#import "CoreDataManager.h"

@interface ManageRoommatesViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray *roommateViewsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedRoommates;

@end

@implementation ManageRoommatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Roommate" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nameRoommate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    
       self.fetchedRoommates = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.fetchedRoommates performFetch:NULL];
    NSLog(@"fetched roommates: %lu", self.fetchedRoommates.fetchedObjects.count);
    for (Roommate *roommate in self.fetchedRoommates.fetchedObjects) {
        RoommateView *newRoommate = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50)];
        newRoommate.roommate = roommate;
        newRoommate.backgroundColor = [UIColor redColor];
        [self.view addSubview:newRoommate];
        [self.view bringSubviewToFront:newRoommate];
        [self.roommateViewsArray addObject:newRoommate];
        NSLog(@"Made a roommateView");
    }
}

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    self.fetchedRoommates = controller;
//    [self.fetchedRoommates performFetch:NULL];
//}


- (void)viewDidDisappear:(BOOL)animated {
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
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
