//
//  LoginViewController.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/17/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "Team.h"

@interface LoginViewController : UIViewController

@property NSFetchedResultsController *fetchedTeams;

@end
