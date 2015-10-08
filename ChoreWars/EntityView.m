//
//  ChoreView.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "EntityView.h"

@interface EntityView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation EntityView

- (id) initWithFrame:(CGRect)frame andEntity:(id)entity WithType:(NSString *)type {
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

        UIPanGestureRecognizer *moveView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanView:)];
        [moveView setMinimumNumberOfTouches:1];
        [moveView setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:moveView];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressView:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    return self;
}

- (void) configureNameLabel {
    NSManagedObject *object = self.entity;
    self.nameLabel.text = [object valueForKey:@"name"];
}

- (void) didLongPressView:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if ([self.delegate respondsToSelector:@selector(entityViewDidLongPress:)]){
            [self.delegate entityViewDidLongPress:self];
        }
    }
}

- (void) didPanView:(UIPanGestureRecognizer *)sender {
        CGPoint translation = [sender translationInView:self.superview];
        CGPoint newPoint = CGPointMake(_lastLocation.x + translation.x,
                                  _lastLocation.y + translation.y);
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (self.delegate) {
            [self.delegate entityView:self willMoveToPoint:newPoint];
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate) {
            [self.delegate entityView:self didMoveToPoint:newPoint];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.superview bringSubviewToFront:self];
    _lastLocation = self.center;
}


@end
