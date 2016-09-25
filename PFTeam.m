//
//  PFTeam.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 10/23/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "PFTeam.h"
#import <Parse/PFObject+Subclass.h>

@implementation PFTeam

- (void) setName:(NSString *)sender {
    [self setValue:sender forKey:@"name"];
}

- (NSString *) getName {
    return [self valueForKey:@"name"];
}

//- (void) setDidWin:(BOOL)sender {
//    [self setValue:sender forKey:@"didWin"];
//}




@end
