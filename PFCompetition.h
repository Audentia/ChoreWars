//
//  PFCompetition.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 10/23/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCompetition : PFObject<PFSubclassing>

// attributes
- (void) setName:(NSString *)sender;
- (NSString *) getName;
- (void)completionDate;
- (void)creationDate;
- (void)reward;
- (void)targetDate;

// relationships
- (void) teams;
- (void) household;


@end
