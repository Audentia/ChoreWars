//
//  ChoreView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "ChoreView.h"

@interface ChoreView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation ChoreView

- (id) initWithFrame:(CGRect)frame andEntity:(id)entity {
    self = [super initWithFrame:frame];
    if (self) {
        self.entity = entity;
        self.backgroundColor = [UIColor redColor];
        
//        CAShapeLayer *circleLayer = [CAShapeLayer layer];
//        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:frame] CGPath]];
//        [[self layer] addSublayer:circleLayer];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self.nameLabel layoutIfNeeded];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self configureNameLabel];
        [self addSubview:self.nameLabel];
        [self bringSubviewToFront:self.nameLabel];

        UIPanGestureRecognizer *moveChoreView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanChore:)];
        [moveChoreView setMinimumNumberOfTouches:1];
        [moveChoreView setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:moveChoreView];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressChore:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}

- (void) configureNameLabel {
    self.chore = self.entity;
    self.nameLabel.text = self.chore.nameChore;
}

- (void) didLongPressChore:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(choreViewDidLongPress:)]){
            [self.delegate choreViewDidLongPress:self];
        }
    }
}

- (void) didPanChore:(UIPanGestureRecognizer *)sender {
        CGPoint translation = [sender translationInView:self.superview];
        self.center = CGPointMake(_lastLocation.x + translation.x,
                                  _lastLocation.y + translation.y);
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate) {
            [self.delegate choreView:self didMoveToPoint:self.center];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    _lastLocation = self.center;
}


@end
