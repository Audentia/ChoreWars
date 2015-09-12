//
//  ManageEntitiesViewController.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamView.h"
#import "RoommateView.h"
#import "Roommate.h"
#import "CoreDataManager.h"

@interface ManageEntitiesViewController : UIViewController

- (void) toggleEditMode;
- (NSFetchedResultsController *) fetchEntitiesWithName:(NSString *)name andSortKey:(NSString *)sortKey;


@property (nonatomic, strong) UIView *trashView;
@property (nonatomic, strong) UIView *unassignTeamsView;
@property (nonatomic, strong) NSMutableArray *teamViewsArray;
@property (nonatomic, strong) NSMutableArray *entityViewsArray;
@property CGPoint entityOriginalCenter;

@end
