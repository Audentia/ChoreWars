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

- (void) entityViewDidLongPress:(EntityView *)entityView {
    [self toggleEditMode];
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
