//
//  CPAAppDelegate.h
//  CarParks
//
//  Created by Andrew Sage on 20/08/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSMutableArray*)getAllCarParkRecords;
- (NSMutableArray*)getFavouriteCarParkRecords;
- (void)refreshDataFromServer;

@end
