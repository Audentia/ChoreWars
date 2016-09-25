//
//  TeamView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/19/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamView.h"

@implementation TeamView

- (id) initWithFrame:(CGRect)frame andTeam:(PFTeam *)team {
    self = [super initWithFrame:frame];
    if (self) {
        self.team = team;
        
        self.backgroundColor = [UIColor blueColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.0f;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.nameLabel layoutIfNeeded];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self configureNameLabel];
        [self addSubview:self.nameLabel];
        [self bringSubviewToFront:self.nameLabel];
    }
    return self;
}

- (void) configureNameLabel {
    self.nameLabel.text = [self.team getName];
}

@end
