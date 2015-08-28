//
//  Competition+CoreDataProperties.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/13/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Competition.h"

NS_ASSUME_NONNULL_BEGIN

@interface Competition (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nameCompetition;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSDate *completionDate;
@property (nullable, nonatomic, retain) NSSet<Team *> *teams;

@end

@interface Competition (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet<Team *> *)values;
- (void)removeTeams:(NSSet<Team *> *)values;

@end

NS_ASSUME_NONNULL_END
