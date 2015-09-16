//
//  Chore+CoreDataProperties.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 9/11/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chore.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *assignDate;
@property (nullable, nonatomic, retain) NSDate *completeDate;
@property (nullable, nonatomic, retain) NSDate *confirmDate;
@property (nullable, nonatomic, retain) NSString *moreInfo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Team *opposingTeam;
@property (nullable, nonatomic, retain) Roommate *roommate;
@property (nullable, nonatomic, retain) Team *team;

@end

NS_ASSUME_NONNULL_END
