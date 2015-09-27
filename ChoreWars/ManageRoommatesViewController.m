//
//  AddRoommatesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageRoommatesViewController.h"

@interface ManageRoommatesViewController () <EntityViewDelegate>


@end

@implementation ManageRoommatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createRoommateViewsFromFetch:[self fetchEntitiesWithName:@"Roommate" andSortKey:@"name"]];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self sendEntities];
}

- (void)sendEntities {
    //    Start the ball
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.entityViewsArray]
                                                   mode:UIPushBehaviorModeInstantaneous];
    int uniqueStartInt = arc4random_uniform(4);
    //    want to make random numbers so long as the sum equals the same magnitude in the equation v = sqr(x^2 + y^2)
    switch (uniqueStartInt) {
        case 0:
            self.pusher.pushDirection = CGVectorMake(0.1, 0.1);
            break;
        case 1:
            self.pusher.pushDirection = CGVectorMake(0.2, 0.05);
            break;
        case 2:
            self.pusher.pushDirection = CGVectorMake(0.05, 0.2);
            break;
        case 3:
            self.pusher.pushDirection = CGVectorMake(-0.1, -0.1);
            break;
            
        default:
            break;
    }
    
    self.pusher.active = YES;
    //    Because push is instantaneous, it will only happen once
    [self.animator addBehavior:self.pusher];
}

- (void)createRoommateViewsFromFetch:(NSFetchedResultsController *)fetch {
    for (Roommate *eachRoommate in fetch.fetchedObjects) {
        RoommateView *roommateView = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:eachRoommate];
        [self.view addSubview:roommateView];
        [self.view bringSubviewToFront:roommateView];
        [self.entityViewsArray addObject:roommateView];
        roommateView.delegate = self;
        NSLog(@"Made a roommateView for %@", eachRoommate.name);
        NSLog(@"entityViewsArray has %lu things in it", (unsigned long)self.entityViewsArray.count);
    }
}

- (void) entityViewDidLongPress:(EntityView *)entityView {
    [self toggleEditMode];
}

- (void) entityView:(EntityView *)entityView willMoveToPoint:(CGPoint)point {
    if (CGRectContainsPoint(self.trashView.frame, point)) {
        [self enlargeView:self.trashView];
    }
    if (!CGRectContainsPoint(self.trashView.frame, point)) {
        [self shrinkViewtoNormalSize:self.trashView];
    }

}

- (void) entityView:(EntityView *)entityView didMoveToPoint:(CGPoint)point {
    Roommate *roommate = entityView.entity;
    NSMutableSet *teamsToRemove = [[NSMutableSet alloc] init];
    BOOL teamAssigned = NO;
    if (CGRectContainsPoint(self.trashView.frame, point)) {
        NSLog(@"drag to trash");
        //core data delete
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:roommate];
        
        NSError *error = nil;
        if (![[CoreDataManager sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.entityViewsArray removeObject:entityView];
        [self shrinkViewtoNormalSize:self.trashView];
        
        //remove the view
        [entityView removeFromSuperview];
    }
    if (CGRectContainsPoint(self.unassignTeamsView.frame, point)){
        if (roommate.teams.count > 0) {
            [roommate removeTeams:roommate.teams];
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            NSLog(@"roommate remove all teams");
        }
    }
    
    for (TeamView *teamView in self.teamViewsArray) {
        if (CGRectContainsPoint(teamView.frame, point)) {
            if (roommate.teams.count > 0) {
                for (Team *eachTeam in roommate.teams) {
                    NSLog(@"This roommate was on team: %@", eachTeam.name);
                    if ([eachTeam.name isEqualToString:teamView.team.name]) {
                        teamAssigned = YES;
                    } else {
                        [teamsToRemove addObject:eachTeam];
                        NSLog(@"This roommate will remove team: %@", eachTeam.name);
                        
                    }
                }
                if (teamAssigned == NO) {
                    [teamView.team addParticipantsObject:roommate];
                    NSLog(@"This roommate will add team: %@", teamView.team.name);
                    
                }
                if (teamsToRemove.count > 0) {
                    [roommate removeTeams:teamsToRemove];
                }
                
            } else {
                [teamView.team addParticipantsObject:roommate];
                NSLog(@"This roommate will add team: %@", teamView.team.name);
                
            }
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        Roommate *aRoommate = anObject;
        RoommateView *newRoommateView = [[RoommateView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:aRoommate];
        [self.view addSubview:newRoommateView];
        [self.view bringSubviewToFront:newRoommateView];
        [self.entityViewsArray addObject:newRoommateView];
        newRoommateView.delegate = self;
        NSLog(@"Made a roommateView for %@", aRoommate.name);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
