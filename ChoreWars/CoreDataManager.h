//
//  coreDataManager.h
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/13/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveDataForItem:(id)detailItem WithName:(NSString *)name WithPhone:(NSString *)phone AndEmail:(NSString *)email;
- (void)saveChore:(id)chore WithName:(NSString *)name;



+ (instancetype) sharedInstance;

@end
