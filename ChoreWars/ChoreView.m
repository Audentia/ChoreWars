//
//  ChoreView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ChoreView.h"

@interface ChoreView ()



@end

@implementation ChoreView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
//        CAShapeLayer *circleLayer = [CAShapeLayer layer];
//        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:frame] CGPath]];
//        [[self layer] addSublayer:circleLayer];


        UIPanGestureRecognizer *moveChoreView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanChore:)];
        [moveChoreView setMinimumNumberOfTouches:1];
        [moveChoreView setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:moveChoreView];
    }
    return self;
}

- (void) didPanChore:(UIPanGestureRecognizer *)sender {
        CGPoint translation = [sender translationInView:self.superview];
        self.center = CGPointMake(_lastLocation.x + translation.x,
                                  _lastLocation.y + translation.y);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    _lastLocation = self.center;
}

@end
