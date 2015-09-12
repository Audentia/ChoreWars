//
//  ManageEntitiesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageEntitiesViewController.h"

@interface ManageEntitiesViewController () <NSFetchedResultsControllerDelegate, ChoreViewDelegate>

@end

@implementation ManageEntitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTeamViewsFromFetch:[self fetchEntitiesWithName:@"Team" andSortKey:@"name"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *) fetchEntitiesWithName:(NSString *)name andSortKey:(NSString *)sortKey {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    
    NSFetchedResultsController *fetchedEntities = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedEntities.delegate = self;
    
    [fetchedEntities performFetch:NULL];
    NSLog(@"fetched %@: %lu", name, fetchedEntities.fetchedObjects.count);
    return fetchedEntities;
}

- (void) createTeamViewsFromFetch:(NSFetchedResultsController *)fetch {
    self.unassignTeamsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.unassignTeamsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.unassignTeamsView];
    [self.view sendSubviewToBack:self.unassignTeamsView];
    
    self.teamViewsArray = [NSMutableArray array];
    CGFloat widthForTeams = self.view.frame.size.width / fetch.fetchedObjects.count;
    CGFloat initialX = 0;
    for (Team *eachTeam in fetch.fetchedObjects) {
        TeamView *newTeamView = [[TeamView alloc] initWithFrame:CGRectMake(initialX, self.view.frame.size.height - 200, widthForTeams, 200) andEntity:eachTeam];
        initialX = initialX + widthForTeams;
        
        [self.view addSubview:newTeamView];
        [self.teamViewsArray addObject:newTeamView];
    }
    
}


- (void) toggleEditMode {
    if (self.trashView == nil) {
        self.trashView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, 64, 70, 70)];
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
    Roommate *roommate = choreView.entity;
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
        [self.roommateViewsArray removeObject:choreView];
        
        //remove the view
        [choreView removeFromSuperview];
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
                    NSLog(@"This roommate was on team: %@", eachTeam.nameTeam);
                    if ([eachTeam.nameTeam isEqualToString:teamView.team.nameTeam]) {
                        teamAssigned = YES;
                    } else {
                        [teamsToRemove addObject:eachTeam];
                        NSLog(@"This roommate will remove team: %@", eachTeam.nameTeam);
                        
                    }
                }
                if (teamAssigned == NO) {
                    [teamView.team addParticipantsObject:roommate];
                    NSLog(@"This roommate will add team: %@", teamView.team.nameTeam);
                    
                }
                if (teamsToRemove.count > 0) {
                    [roommate removeTeams:teamsToRemove];
                }
                
            } else {
                [teamView.team addParticipantsObject:roommate];
                NSLog(@"This roommate will add team: %@", teamView.team.nameTeam);
                
            }
            [[CoreDataManager sharedInstance].managedObjectContext save:NULL];
            break;
        }
    }
}

@end
