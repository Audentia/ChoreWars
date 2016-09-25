//
//  PFHousehold.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 1/1/16.
//  Copyright © 2016 madebydouglas. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFHousehold : PFObject

// attributes
- (void) setName:(NSString *)sender;
- (NSString *) getName;
- (void) invitePIN;

// relationships
- (void) competitions;
- (void) participants;
- (void) teams;

@end
