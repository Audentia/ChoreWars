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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end