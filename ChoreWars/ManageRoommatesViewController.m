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
    self.type = @"Roommate";
    [super viewDidLoad];
}

#pragma mark - Delegate Methods

- (void) entityViewDidLongPress:(EntityView *)entityView {
    [self toggleEditMode];
    [self.view bringSubviewToFront:entityView];
}

- (void) entityView:(EntityView *)entityView willMoveToPoint:(CGPoint)point {
    CGPoint touchCenter = CGPointMake(point.x - (entityView.frame.size.width / 2), point.y - (entityView.frame.size.height / 2));
    CGRect potentialNewFrame = CGRectMake(touchCenter.x, touchCenter.y, entityView.frame.size.width, entityView.frame.size.height);
    CGRect safeBounds = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height - (self.navigationController.navigationBar.frame.size.height +20));
    if (CGRectContainsRect(safeBounds, potentialNewFrame)) {
        entityView.center = point;
        if (CGRectContainsPoint(self.trashView.frame, point)) {
            [self enlargeView:self.trashView];
        }
        if (!CGRectContainsPoint(self.trashView.frame, point)) {
            [self shrinkViewtoNormalSize:self.trashView];
        }
    }
}

- (void) entityView:(EntityView *)entityView didMoveToPoint:(CGPoint)point {
    Roommate *roommate = entityView.entity;
    NSMutableSet *teamsToRemove = [[NSMutableSet alloc] init];
    BOOL teamAssigned = NO;
    
    if (CGRectContainsPoint(self.trashView.frame, point)) {
        NSLog(@"drag to trash");
        //core data delete
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:entityView.entity];
        
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
@end
