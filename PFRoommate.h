//
//  PFRoommate.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 1/1/16.
//  Copyright © 2016 madebydouglas. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFRoommate : PFObject

// attributes
- (void) setName:(NSString *)sender;
- (NSString *) getName;
- (void) email;
- (void) phoneNumber;
- (void) profilePicture;

// relationships
- (void) completedChores;
- (void) teams;
- (void) household;


@end
