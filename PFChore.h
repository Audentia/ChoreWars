//
//  PFChore.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 10/23/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFChore : PFObject<PFSubclassing>

// attributes
- (void) setName:(NSString *)sender;
- (NSString *) getName;
- (void) assignDate;
- (void) completeDate;
- (void) confirmDate;
- (void) moreInfo;

// relationships
- (void) opposingTeam;
- (void) roommate;
- (void) team;

@end
