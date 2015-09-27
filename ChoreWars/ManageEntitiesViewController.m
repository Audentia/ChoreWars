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
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.entityViewsArray = [[NSMutableArray alloc] init];
    [self createTeamViewsFromFetch:[self fetchEntitiesWithName:@"Team" andSortKey:@"name"]];
}

- (void)createCollisions {
    self.collider = [[UICollisionBehavior alloc] initWithItems:self.entityViewsArray];
    //    self.collider.collisionDelegate = self.paddleView;
    self.collider.collisionMode = UICollisionBehaviorModeEverything;
    [self.collider addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, self.view.frame.size.height)];
    [self.collider addBoundaryWithIdentifier:@"right" fromPoint:CGPointMake(self.view.frame.size.width, 0) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.collider addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, self.view.frame.size.height - 200) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height - 200)];
    [self.animator addBehavior:self.collider];
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
    self.fetchedEntities = fetchedEntities;
    self.fetchedEntities.delegate = self;
    
    [self.fetchedEntities performFetch:NULL];
    NSLog(@"fetched %@: %lu", name, self.fetchedEntities.fetchedObjects.count);
    return self.fetchedEntities;
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

- (void) shakeView:(UIView *)view {
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.2];
    [animation setRepeatCount:8];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([view center].x - 20.0f, [view center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([view center].x + 20.0f, [view center].y)]];
    [[view layer] addAnimation:animation forKey:@"position"];
}

- (void) wiggleViews:(NSArray *)array {
    for (UIView *view in array) {
        view.transform = CGAffineTransformMakeRotation(-.1);
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction animations:^{
            view.transform = CGAffineTransformMakeRotation(.1);
        } completion:nil];
    }
}

- (void) stopWigglingViews:(NSArray *)array {
    for (UIView *view in array) {
        [UIView animateWithDuration:0.15 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (void) enlargeView:(UIView *)view {
    [UIView animateWithDuration:.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:nil];
}

- (void) shrinkViewtoNormalSize:(UIView *)view {
     [UIView animateWithDuration:.3 animations:^{
         view.transform = CGAffineTransformIdentity;
         } completion:nil];
}

- (void) toggleEditMode {
    if (self.trashView == nil) {
        self.trashView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 35, 64, 70, 70)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        imageView.image = [UIImage imageNamed:@"empty_trash.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.trashView addSubview:imageView];
        [self.view addSubview:self.trashView];
        [self wiggleViews:self.entityViewsArray];
        
        
    } else {
        [self.trashView removeFromSuperview];
        self.trashView = nil;
        [self stopWigglingViews:self.entityViewsArray];
    }
}

@end
