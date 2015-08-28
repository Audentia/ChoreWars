//
//  RoommateView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/19/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "RoommateView.h"

@implementation RoommateView

- (void) configureNameLabel {
    self.roommate = self.entity;
    self.nameLabel.text = self.roommate.nameRoommate;
}

@end
