//
//  CPAAppDelegate.m
//  CarParks
//
//  Created by Andrew Sage on 20/08/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import "CPAAppDelegate.h"
#import "CarPark.h"

@implementation CPAAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.090 green:0.494 blue:0.984 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.090 green:0.494 blue:0.984 alpha:1]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CarPark" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CarPark.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSMutableArray*)getAllCarParkRecords {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarPark"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *fetchedRecords = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (NSMutableArray*)getFavouriteCarParkRecords {
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CarPark"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"favourite == YES"];
    
    [fetchRequest setPredicate:namePredicate];
    
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSMutableArray *fetchedRecords = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (void)refreshDataFromServer {
    
    NSString *urlString = @"http://open311.xoverto.com/dev/v1/facilities/parking.json";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    request.timeoutInterval = 240;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if(error) {
                                   NSLog(@"Connection failed: %@", error.localizedDescription);
                               } else {
                                   NSLog(@"We sent to: %@", response.URL);
                                   NSLog(@"Connection did receive response: %@", response);
                                   
                                   NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   
                                    NSLog(@"Data received: %@", dataAsString);
                                   
                                   NSError *jsonError;
                                   NSArray *jsonArray = nil;
                                   NSDictionary *jsonDictionary = nil;
                                   
                                   id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                                   
                                   if ([jsonObject isKindOfClass:[NSArray class]]) {
                                       jsonArray = (NSArray *)jsonObject;
                                   }
                                   else {
                                       jsonDictionary = (NSDictionary *)jsonObject;
                                   }
                                   
                                   for(NSDictionary *carParkDictionary in jsonArray) {
                                       NSLog(@"%@", carParkDictionary);
                                       
                                       NSArray *localeObjectsArray = [self getLocalObjectFrom:@"CarPark" forToken:[carParkDictionary objectForKey:@"id"]];
                                       
                                       if(localeObjectsArray.count > 0) {
                                           // Update existing record
                                           
                                           CarPark *carPark = localeObjectsArray.firstObject;
                                           [carPark updateWithDictionary:carParkDictionary];
                                           
                                                                                      
                                       } else {
                                           // Add a new record
                                           CarPark *carPark = [NSEntityDescription insertNewObjectForEntityForName:@"CarPark" inManagedObjectContext:self.managedObjectContext];
                                           
                                           carPark.favourite = NO;
                                           
                                           carPark.publicID = [carParkDictionary objectForKey:@"id"];
                                           carPark.name = [carParkDictionary objectForKey:@"facility_name"];
                                           
                                           [carPark updateWithDictionary:carParkDictionary];
                                       }
                                   }
                                   
                                   [self.managedObjectContext save:nil];

                               }

                           }];

    
}

- (NSArray *)getLocalObjectFrom:(NSString *)remoteClassName forToken:(NSString *)token
{
    NSFetchRequest *searchFetchRequest;
    searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:remoteClassName inManagedObjectContext:self.managedObjectContext];
    [searchFetchRequest setEntity:entity];
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"publicID CONTAINS[cd] %@", token];
    
    [searchFetchRequest setPredicate:namePredicate];
    NSError *error = nil;
    NSArray *localObjectsArray = [self.managedObjectContext executeFetchRequest:searchFetchRequest error:&error];
    return localObjectsArray;
}
                                   
@end
