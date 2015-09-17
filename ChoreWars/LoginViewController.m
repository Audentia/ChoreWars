//
//  LoginViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    
    self.fetchedTeams = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        [self.fetchedTeams performFetch:NULL];
    
    if (self.fetchedTeams.fetchedObjects.count == 0) {
        Team *teamA = [[Team alloc] initWithEntity:entity insertIntoManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
        teamA.name = @"TeamA";
        teamA.didWin = 0;
        Team *teamB = [[Team alloc] initWithEntity:entity insertIntoManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
        teamB.name = @"TeamB";
        teamB.didWin = 0;
        [self.fetchedTeams performFetch:NULL];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedTeams.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    Team *team = [self.fetchedTeams.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = team.name;

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Team *team = [self.fetchedTeams.fetchedObjects objectAtIndex:indexPath.row];
    [CoreDataManager sharedInstance].currentTeam = team;
}

//SomeViewController *someViewController = [storyboard instantiateViewControllerWithIdentifier:@"SomeViewController"];


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
