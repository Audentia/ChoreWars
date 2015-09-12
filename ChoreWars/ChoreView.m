//
//  ChoreView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/12/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ChoreView.h"

@implementation ChoreView

- (void) configureNameLabel {
    self.chore = self.entity;
    self.nameLabel.text = self.chore.name;
}

@end
