//
//  TeamView.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/19/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface TeamView : UIView

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) Team *team;

- (id) initWithFrame:(CGRect)frame andTeam:(Team *)team;

@end
