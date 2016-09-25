//
//  ManageEntitiesViewController.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ManageEntitiesViewController.h"
#import <Parse/Parse.h>

@interface ManageEntitiesViewController () <NSFetchedResultsControllerDelegate, EntityViewDelegate>

@end

@implementation ManageEntitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.entityViewsArray = [[NSMutableArray alloc] init];
    [self createTeamViewsFromFetch:[self fetchEntitiesWithName:@"Team" andSortKey:@"name"]];
    [self createEntityViewsFromFetch:[self fetchEntitiesWithName:self.type andSortKey:@"name"] WithType:self.type];
}


#pragma mark - Fetch Entites and Make EntityViews

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

- (void)createEntityViewsFromFetch:(NSFetchedResultsController *)fetch WithType:(NSString *)type {
    for (NSManagedObject *eachEntity in fetch.fetchedObjects) {
        CGRect frame = [self newEntityFrame];
        CGRect teamFrame = CGRectMake(10, self.view.bounds.size.height - self.teamViewHeight, self.entityWidth, self.entityHeight);

//        if ([_type isEqualToString:@"Roommate"]) {
//            if ([[eachEntity valueForKey:@"teams"] isEqualToString:@"TeamA"]) {
//                frame = teamFrame;
//            }
//        } else {
//            if ([[eachEntity valueForKey:@"team"] isEqualToString:@"TeamA"]) {
//                frame = teamFrame;
//            }
//        }
        EntityView *entityView = [[EntityView alloc] initWithFrame:frame andEntity:eachEntity WithType:type];
        [self.view addSubview:entityView];
        [self.view bringSubviewToFront:entityView];
        [self.entityViewsArray addObject:entityView];
        entityView.delegate = self;
        NSLog(@"Made a roommateView for %@", [entityView.entity valueForKey:@"name"]);
        NSLog(@"entityViewsArray has %lu things in it", (unsigned long)self.entityViewsArray.count);
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (type == NSFetchedResultsChangeInsert) {
        EntityView *newEntityView = [[EntityView alloc] initWithFrame:[self newEntityFrame] andEntity:anObject WithType:self.type];
        [self.view addSubview:newEntityView];
        [self.view bringSubviewToFront:newEntityView];
        [self.entityViewsArray addObject:newEntityView];
        newEntityView.delegate = self;
        NSLog(@"Made a entityView for %@", newEntityView.nameLabel.text);
    }
}

#pragma mark - TeamViews and Edit Mode

- (void) createTeamViewsFromFetch:(NSFetchedResultsController *)fetch {
    self.teamViewHeight = 160;
    self.unassignTeamsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.teamViewHeight)];
    self.unassignTeamsView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.unassignTeamsView];
    [self.view sendSubviewToBack:self.unassignTeamsView];
    
    self.teamViewsArray = [NSMutableArray array];
    CGFloat widthForTeams = self.view.frame.size.width / fetch.fetchedObjects.count;
    CGFloat initialX = 0;
    for (Team *eachTeam in fetch.fetchedObjects) {
        TeamView *newTeamView = [[TeamView alloc] initWithFrame:CGRectMake(initialX, self.view.frame.size.height - self.teamViewHeight, widthForTeams, self.teamViewHeight) andTeam:eachTeam];
        initialX = initialX + widthForTeams;
        
        [self.view addSubview:newTeamView];
        [self.teamViewsArray addObject:newTeamView];
    }
    
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

}

#pragma mark - Custom Rects

- (CGRect) newEntityFrame {
    self.entityWidth = 60;
    self.entityHeight = 60;
    int navigationHeight = self.navigationController.navigationBar.frame.size.height + 20;
    
    CGFloat rangeWidth = self.view.bounds.size.width - self.entityWidth;
    CGFloat rangeHeight = self.view.bounds.size.height - navigationHeight - self.teamViewHeight - self.entityHeight;
    CGFloat uniqueXStart = arc4random_uniform(rangeWidth);
    CGFloat uniqueYStart = arc4random_uniform(rangeHeight);
    
//    CGFloat potentialXValue = self.view.frame.size.width / uniqueStart;
//    CGFloat potentialYValue = self.view.frame.size.height / uniqueStart;
    
    return CGRectMake(uniqueXStart, uniqueYStart + navigationHeight, self.entityWidth, self.entityHeight);
}

#pragma mark - Animations

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

#pragma mark - Adding UIKit Dynamics

- (void)createCollisions {
    self.collider = [[UICollisionBehavior alloc] initWithItems:self.entityViewsArray];
    //    self.collider.collisionDelegate = self.paddleView;
    self.collider.collisionMode = UICollisionBehaviorModeEverything;
    [self.collider addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, self.view.frame.size.height)];
    [self.collider addBoundaryWithIdentifier:@"right" fromPoint:CGPointMake(self.view.frame.size.width, 0) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.collider addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, self.view.frame.size.height - 200) toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height - 200)];
    [self.animator addBehavior:self.collider];
}

- (void)sendEntities {
    //    Start the ball
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.entityViewsArray]
                                                   mode:UIPushBehaviorModeInstantaneous];
    int uniqueStartInt = arc4random_uniform(4);
    //    want to make random numbers so long as the sum equals the same magnitude in the equation v = sqr(x^2 + y^2)
    switch (uniqueStartInt) {
        case 0:
            self.pusher.pushDirection = CGVectorMake(0.1, 0.1);
            break;
        case 1:
            self.pusher.pushDirection = CGVectorMake(0.2, 0.05);
            break;
        case 2:
            self.pusher.pushDirection = CGVectorMake(0.05, 0.2);
            break;
        case 3:
            self.pusher.pushDirection = CGVectorMake(-0.1, -0.1);
            break;
            
        default:
            break;
    }
    
    self.pusher.active = YES;
    //    Because push is instantaneous, it will only happen once
    [self.animator addBehavior:self.pusher];
}


@end
