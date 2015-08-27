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
#import "TrashView.h"

@interface ManageRoommatesViewController () <NSFetchedResultsControllerDelegate, ChoreViewDelegate>

@property (nonatomic, strong) NSMutableArray *roommateViewsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedRoommates;
@property CGPoint roommateOriginalCenter;
@property (nonatomic, strong) TrashView *trashView;
@property (nonatomic, strong) TeamView *teamView;


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
    self.fetchedRoommates.delegate = self;
    
    [self.fetchedRoommates performFetch:NULL];
    NSLog(@"fetched roommates: %lu", self.fetchedRoommates.fetchedObjects.count);
    [self createRoommateViews];
    [self createTeamViews];
    
}

- (void) createTeamViews {
    CGFloat widthForTwoTeams = self.view.frame.size.width / 2;
    CGFloat initialX = 0;
    for (int i = 0; i <= 1; i++) {
        self.teamView = [[TeamView alloc] initWithFrame:CGRectMake(initialX, self.view.frame.size.height - 200, widthForTwoTeams, 200)];
        initialX = initialX + widthForTwoTeams;
        self.teamView.backgroundColor = [UIColor blueColor];
        self.teamView.layer.borderColor = [UIColor blackColor].CGColor;
        self.teamView.layer.borderWidth = 2.0f;
        [self.view addSubview:self.teamView];
    }
}

- (void)createRoommateViews {
    for (Roommate *eachRoommate in self.fetchedRoommates.fetchedObjects) {
        RoommateView *newRoommateView = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:eachRoommate];
        [self.view addSubview:newRoommateView];
        [self.view bringSubviewToFront:newRoommateView];
        [self.roommateViewsArray addObject:newRoommateView];
        newRoommateView.delegate = self;
        NSLog(@"Made a roommateView for %@", eachRoommate.nameRoommate);
    }
}

- (void) toggleEditMode {
    if (self.trashView == nil) {
        self.trashView = [[TrashView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, 64, 70, 70)];
        [self.trashView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:self.trashView];
    } else {
        [self.trashView removeFromSuperview];
        self.trashView = nil;
    }
}

- (void) choreViewDidLongPress:(ChoreView *)choreView {
    [self toggleEditMode];
}

- (void) choreView:(ChoreView *)choreView didMoveToPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.trashView.frame, point)) {
        NSLog(@"drag to trash");
        //core data delete
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:choreView.entity];
        
        NSError *error = nil;
        if (![[CoreDataManager sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.roommateViewsArray removeObject:choreView];
        
        //remove the view
        [choreView removeFromSuperview];
    }
    if (CGRectContainsPoint(self.teamView, point)) {
        NSLog(@"Assign to team: %@", )
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
