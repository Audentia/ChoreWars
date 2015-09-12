//
//  TeamPickChoresViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/28/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamPickChoresViewController.h"

@interface TeamPickChoresViewController () <NSFetchedResultsControllerDelegate, ChoreViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedChores;
@property (nonatomic, strong) NSMutableArray *choreViewsArray;


@end

@implementation TeamPickChoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showRoommates {
    NSFetchRequest *fetchRequestRoommate = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityRoommate = [NSEntityDescription entityForName:@"Chore" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptorRoommate = [[NSSortDescriptor alloc] initWithKey:@"nameChore" ascending:YES];
    NSArray *sortDescriptorsRoommate = @[sortDescriptorRoommate];
    
    [fetchRequestRoommate setSortDescriptors:sortDescriptorsRoommate];
    [fetchRequestRoommate setEntity:entityRoommate];
    
    self.fetchedChores = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestRoommate managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedChores.delegate = self;
    
    [self.fetchedChores performFetch:NULL];
    NSLog(@"fetched chores: %lu", self.fetchedChores.fetchedObjects.count);
    [self createChoreViews];
}

- (void)createChoreViews {
    for (Chore *eachChore in self.fetchedChores.fetchedObjects) {
        ChoreView *newChoreView = [[ChoreView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:eachChore];
        [self.view addSubview:newChoreView];
        [self.view bringSubviewToFront:newChoreView];
        [self.choreViewsArray addObject:newChoreView];
        newChoreView.delegate = self;
        NSLog(@"Made a roommateView for %@", eachChore.name);
    }
}

- (void) choreViewDidLongPress:(ChoreView *)choreView {
    [super toggleEditMode];
}

- (void) choreView:(ChoreView *)choreView didMoveToPoint:(CGPoint)point {
    Chore *chore = choreView.entity;
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
        [self.choreViewsArray removeObject:choreView];
        
        //remove the view
        [choreView removeFromSuperview];
    }
    if (CGRectContainsPoint(self.unassignTeamsView.frame, point)) {
        if (chore.team != nil) {
            chore.team = nil;
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            NSLog(@"roommate remove all teams");
        }
    }
    
    for (TeamView *teamView in self.teamViewsArray) {
        if (CGRectContainsPoint(teamView.frame, point)) {
            if (chore.team != nil) {
                    NSLog(@"This roommate was on team: %@", chore.team.name);
                    if ([chore.team.name isEqualToString:teamView.team.name]) {
                        teamAssigned = YES;
                    } else {
                        [teamsToRemove addObject:chore.team];
                        NSLog(@"This roommate will remove team: %@", chore.team.name);
                        
                    }
            
                if (teamAssigned == NO) {
                    [teamView.team addChoresToWinObject:chore];
                    NSLog(@"This roommate will add team: %@", teamView.team.name);
                    
                }
                if (teamsToRemove.count > 0) {
                    chore.team = nil;
                }
                
            } else {
                [teamView.team addChoresToWinObject:chore];
                NSLog(@"This roommate will add team: %@", teamView.team.name);
                
            }
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
