//
//  TeamPickChoresViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/28/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamPickChoresViewController.h"

@interface TeamPickChoresViewController () <NSFetchedResultsControllerDelegate, EntityViewDelegate>

@end

@implementation TeamPickChoresViewController

- (void)viewDidLoad {
    self.type = @"Chore";
    [super viewDidLoad];
}

#pragma mark - Delegate Methods

- (void) entityViewDidLongPress:(EntityView *)choreView {
    [super toggleEditMode];
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
    Chore *chore = entityView.entity;
    NSMutableSet *teamsToRemove = [[NSMutableSet alloc] init];
    BOOL teamAssigned = NO;
    if (CGRectContainsPoint(self.trashView.frame, point)) {
        NSLog(@"drag to trash");
        //core data delete
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:chore];
        
        NSError *error = nil;
        if (![[CoreDataManager sharedInstance].managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [self.entityViewsArray removeObject:entityView];
        
        //remove the view
        [entityView removeFromSuperview];
    }
    if (CGRectContainsPoint(self.unassignTeamsView.frame, point)) {
        if (chore.team != nil) {
            chore.team = nil;
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            NSLog(@"chore remove all teams");
        }
    }
    
    for (TeamView *teamView in self.teamViewsArray) {
        if (CGRectContainsPoint(teamView.frame, point)) {
            if (chore.team != nil) {
                    NSLog(@"This chore was on team: %@", chore.team.name);
                    if ([chore.team.name isEqualToString:teamView.team.name]) {
                        teamAssigned = YES;
                    } else {
                        [teamsToRemove addObject:chore.team];
                        NSLog(@"This chore will remove team: %@", chore.team.name);
                        
                    }
            
                if (teamAssigned == NO) {
                    [teamView.team addChoresToWinObject:chore];
                    NSLog(@"This chore will add team: %@", teamView.team.name);
                    
                }
                if (teamsToRemove.count > 0) {
                    chore.team = nil;
                }
                
            } else {
                [teamView.team addChoresToWinObject:chore];
                NSLog(@"This chore will add team: %@", teamView.team.name);
                
            }
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            break;
        }
    }
}

@end
