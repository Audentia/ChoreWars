//
//  coreDataManager.m
//  ChoreWars
//
//  Created by Douglas Hewitt on 8/13/15.
//  Copyright © 2015 madebydouglas. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype) sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "madebydouglas.ChoreWars" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ChoreWars" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ChoreWars.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)saveChore:(id)chore WithName:(NSString *)name {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newChore = [NSEntityDescription insertNewObjectForEntityForName:@"Chore" inManagedObjectContext:context];
    [newChore setValue:name forKey:@"name"];
    NSError *error;
    [context save:&error];
}

//- (void)saveCompetition:(id)competition WithName:(NSString *)name AndCreationDate:(NSDate *)cDate AndTargetDate:(NSDate *)tDate {
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObject *newCompetition = [NSEntityDescription insertNewObjectForEntityForName:@"Competition" inManagedObjectContext:context];
//    [newCompetition setValue:name forKey:@"name"];
//    [newCompetition setValue:cDate forKey:@"creationDate"];
//    [newCompetition setValue:tDate forKey:@"targetDate"];
//    
//    NSError *error;
//    [context save:&error];
//}

- (void)saveDataForItem:(id)detailItem WithName:(NSString *)name WithPhone:(NSString *)phone AndEmail:(NSString *)email {
    //    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (detailItem) {
        if (![[detailItem valueForKey:@"name"] isEqualToString:name] || ![[detailItem valueForKey:@"phoneNumber"] isEqualToString:phone] || ![[detailItem valueForKey:@"email"] isEqualToString:email]) {
            [detailItem setValue:name forKey:@"name"];
            [detailItem setValue:phone forKey:@"phoneNumber"];
            [detailItem setValue:email forKey:@"email"];
//            [detailItem setValue:[NSDate date] forKey:@"timeStamp"];
            NSError *error;
            [context save:&error];
        } else {
            // do nothing
            NSLog(@"No changes to existing roommate, will not save");
        }
        
        
        
        
    } else if (name.length == 0 && phone.length == 0 && email.length == 0) {
        //do nothing
        NSLog(@"blank roommate, will not save");
    } else {
        NSManagedObject *newRoommate = [NSEntityDescription insertNewObjectForEntityForName:@"Roommate" inManagedObjectContext:context];
        [newRoommate setValue:name forKey:@"name"];
        [newRoommate setValue:phone forKey:@"phoneNumber"];
        [newRoommate setValue:email forKey:@"email"];
//        [newRoommate setValue: [NSDate date] forKey:@"timeStamp"];
        
        NSError *error;
        [context save:&error];
    }
    
}

@end
