//
//  Roommate+CoreDataProperties.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/13/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Roommate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Roommate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *nameRoommate;
@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSSet<Chore *> *completedChores;
@property (nullable, nonatomic, retain) NSSet<Team *> *teams;

@end

@interface Roommate (CoreDataGeneratedAccessors)

- (void)addCompletedChoresObject:(Chore *)value;
- (void)removeCompletedChoresObject:(Chore *)value;
- (void)addCompletedChores:(NSSet<Chore *> *)values;
- (void)removeCompletedChores:(NSSet<Chore *> *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet<Team *> *)values;
- (void)removeTeams:(NSSet<Team *> *)values;

@end

NS_ASSUME_NONNULL_END
