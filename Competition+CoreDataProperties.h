//
//  Competition+CoreDataProperties.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Competition.h"

NS_ASSUME_NONNULL_BEGIN

@interface Competition (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *completionDate;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Team *> *teams;

@end

@interface Competition (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet<Team *> *)values;
- (void)removeTeams:(NSSet<Team *> *)values;

@end

NS_ASSUME_NONNULL_END
