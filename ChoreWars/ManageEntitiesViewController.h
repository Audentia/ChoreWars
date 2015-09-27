//
//  ManageEntitiesViewController.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamView.h"
#import "Team.h"
#import "EntityView.h"
#import "CoreDataManager.h"

@interface ManageEntitiesViewController : UIViewController

- (void) toggleEditMode;
- (NSFetchedResultsController *) fetchEntitiesWithName:(NSString *)name andSortKey:(NSString *)sortKey;
//- (void)sendEntities;


@property (nonatomic, strong) UIView *trashView;
@property (nonatomic, strong) UIView *unassignTeamsView;
@property (nonatomic, strong) NSMutableArray *teamViewsArray;
@property (nonatomic, strong) NSMutableArray *entityViewsArray;
@property (nonatomic, strong) NSFetchedResultsController *fetchedEntities;

@property CGPoint entityOriginalCenter;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIPushBehavior *pusher;
@property (nonatomic, strong) UICollisionBehavior *collider;

@end
