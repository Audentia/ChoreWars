//
//  AddRoommatesViewController.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamView.h"
#import "RoommateView.h"
#import "Roommate.h"
#import "CoreDataManager.h"
#import "TrashView.h"

@interface ManageRoommatesViewController : UIViewController

- (void) toggleEditMode;

@property (nonatomic, strong) TrashView *trashView;
@property (nonatomic, strong) UIView *unassignTeamsView;
@property (nonatomic, strong) NSMutableArray *teamViewsArray;




@end
