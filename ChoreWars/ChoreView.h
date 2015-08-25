//
//  ChoreView.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/9/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chore.h"

@interface ChoreView : UIView

@property CGPoint lastLocation;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) id entity;
@property (nonatomic, strong) Chore *chore;

- (id) initWithFrame:(CGRect)frame andEntity:(id)entity;


@end
