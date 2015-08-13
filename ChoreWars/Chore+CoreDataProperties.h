//
//  Chore+CoreDataProperties.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/13/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Chore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *moreInfo;
@property (nullable, nonatomic, retain) NSNumber *isComplete;
@property (nullable, nonatomic, retain) NSDate *assignDate;
@property (nullable, nonatomic, retain) NSDate *completeDate;
@property (nullable, nonatomic, retain) NSDate *confirmDate;
@property (nullable, nonatomic, retain) NSNumber *isConfirmed;
@property (nullable, nonatomic, retain) NSNumber *isAssigned;
@property (nullable, nonatomic, retain) Roommate *roommate;
@property (nullable, nonatomic, retain) Team *team;
@property (nullable, nonatomic, retain) Team *opposingTeam;

@end

NS_ASSUME_NONNULL_END
