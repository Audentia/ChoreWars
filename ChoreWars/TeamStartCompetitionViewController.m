//
//  TeamStartCompetitionViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/28/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamStartCompetitionViewController.h"


@interface TeamStartCompetitionViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *completionDate;
@property NSFetchedResultsController *fetchedEntities;
@property (weak, nonatomic) IBOutlet UIPickerView *rewardPickerView;
@property (strong, nonatomic) NSArray *rewardOptions;

@end

@implementation TeamStartCompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datePicker setTimeZone:[NSTimeZone localTimeZone]];
    [self.datePicker setCalendar:[NSCalendar currentCalendar]];
    [self.datePicker setMinimumDate:[NSDate date]];
    [self.datePicker setMaximumDate:[[NSDate date] addTimeInterval:60 * 24 * 60 * 60]];
    [self.datePicker setDate:[NSDate date] animated:YES];
    
    self.rewardOptions = @[@"Social Shame", @"Pizza", @"Beer"];
    
}
- (IBAction)didPressDoneButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectDate:(UIDatePicker *)sender {
    self.completionDate = self.datePicker.date;
}

#pragma mark - Rewards Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return self.rewardOptions.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.rewardOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"Picked %ld for reward", row);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSManagedObjectContext *context = [CoreDataManager sharedInstance].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Competition" inManagedObjectContext:context];
    
    Competition *newCompetition = [[Competition alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    NSSet *fetchedTeams = [[NSSet alloc] initWithArray:[self fetchEntitiesWithName:@"Team" andSortKey:@"name"].fetchedObjects];

    newCompetition.teams = fetchedTeams;
    newCompetition.name = @"competition";
    newCompetition.creationDate = [NSDate date];
    newCompetition.targetDate = self.datePicker.date;
    
    NSError *error;
    [context save:&error];
    NSLog(@"the target date is %@", newCompetition.targetDate);
}

- (NSFetchedResultsController *) fetchEntitiesWithName:(NSString *)name andSortKey:(NSString *)sortKey {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    
    NSFetchedResultsController *fetchedEntities = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataManager sharedInstance].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedEntities = fetchedEntities;
//    self.fetchedEntities.delegate = self;
    
    [self.fetchedEntities performFetch:NULL];
    NSLog(@"fetched %@: %lu", name, self.fetchedEntities.fetchedObjects.count);
    return self.fetchedEntities;
}


@end
