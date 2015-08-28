//
//  ChoreView.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamView.h"
#import "Chore.h"

@class ChoreView;

@protocol ChoreViewDelegate <NSObject>

- (void) choreView:(ChoreView *)choreView didMoveToPoint:(CGPoint)point;
- (void) choreViewDidLongPress:(ChoreView *)choreView;

@end

@interface ChoreView : TeamView

@property CGPoint lastLocation;
@property (nonatomic, strong) Chore *chore;

@property (nonatomic, weak) id <ChoreViewDelegate> delegate;


@end
