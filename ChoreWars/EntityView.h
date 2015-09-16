//
//  ChoreView.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "TeamView.h"
#import "Chore.h"
#import "Roommate.h"

@class EntityView;

@protocol EntityViewDelegate <NSObject>

- (void) entityView:(EntityView *)entityView didMoveToPoint:(CGPoint)point;
- (void) entityViewDidLongPress:(EntityView *)entityView;

@end

@interface EntityView : TeamView

@property CGPoint lastLocation;

@property (nonatomic, weak) id <EntityViewDelegate> delegate;


@end
