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
@property (nonatomic, strong) NSMutableArray *teamViewsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedRoommates;
@property (nonatomic, strong) NSFetchedResultsController *fetchedTeams;
@property CGPoint roommateOriginalCenter;
@property (nonatomic, strong) TrashView *trashView;
@property (nonatomic, strong) UIView *unassignTeamsView;

@end

@implementation ManageRoommatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSFetchRequest *fetchRequestRoommate = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityRoommate = [NSEntityDescription entityForName:@"Roommate" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptorRoommate = [[NSSortDescriptor alloc] initWithKey:@"nameRoommate" ascending:YES];
    NSArray *sortDescriptorsRoommate = @[sortDescriptorRoommate];
    
    [fetchRequestRoommate setSortDescriptors:sortDescriptorsRoommate];
    [fetchRequestRoommate setEntity:entityRoommate];
    
       self.fetchedRoommates = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestRoommate managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedRoommates.delegate = self;
    
    [self.fetchedRoommates performFetch:NULL];
    NSLog(@"fetched roommates: %lu", self.fetchedRoommates.fetchedObjects.count);
    [self createRoommateViews];
    
    
    NSFetchRequest *fetchRequestTeam = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityTeam = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptorTeam = [[NSSortDescriptor alloc] initWithKey:@"nameTeam" ascending:YES];
    NSArray *sortDescriptorsTeam = @[sortDescriptorTeam];
    
    [fetchRequestTeam setSortDescriptors:sortDescriptorsTeam];
    [fetchRequestTeam setEntity:entityTeam];
    
    self.fetchedTeams = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequestTeam managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchedTeams performFetch:NULL];
    [self createTeamViews];
}

- (void) createTeamViews {
    self.unassignTeamsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.unassignTeamsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.unassignTeamsView];
    [self.view sendSubviewToBack:self.unassignTeamsView];

    self.teamViewsArray = [NSMutableArray array];
    CGFloat widthForTeams = self.view.frame.size.width / self.fetchedTeams.fetchedObjects.count;
    CGFloat initialX = 0;
    for (Team *eachTeam in self.fetchedTeams.fetchedObjects) {
        TeamView *newTeamView = [[TeamView alloc] initWithFrame:CGRectMake(initialX, self.view.frame.size.height - 200, widthForTeams, 200) andEntity:eachTeam];
        initialX = initialX + widthForTeams;

        [self.view addSubview:newTeamView];
        [self.teamViewsArray addObject:newTeamView];
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
