//
//  ManageEntitiesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageEntitiesViewController.h"

@interface ManageEntitiesViewController () <NSFetchedResultsControllerDelegate>

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

//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    if (type == NSFetchedResultsChangeInsert) {
//        EntityView *newEntityView = [[EntityView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 50, 50) andEntity:anObject];
//        [self.view addSubview:newEntityView];
//        [self.view bringSubviewToFront:newEntityView];
//        [self.entityViewsArray addObject:newEntityView];
//        newEntityView.delegate = self;
//        NSLog(@"Made a entityView for %@", newEntityView.nameLabel.text);
//    }
//}


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

@end
