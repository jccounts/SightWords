//
//  AppDelegate.m
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "DetailViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;
@synthesize soundEnabled = _soundEnabled;
@synthesize voiceType = _voiceType;
@synthesize selectedThemeRow = _selectedThemeRow;


NSString *kSoundEnabledKey = @"soundEnabled";
NSString *kVoiceTypeKey    = @"voiceType";
NSString *kThemeRowKey     = @"themeRow";


+ (AppDelegate *) delegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        // Handle the error.
        NSLog(@"crap no context!!!!!");
    }

    
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPhone" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
        masterViewController.managedObjectContext = self.managedObjectContext;
    } else {
        MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController_iPad" bundle:nil];
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad" bundle:nil];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    	
    	masterViewController.detailViewController = detailViewController;
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = detailViewController;
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
        
        self.window.rootViewController = self.splitViewController;
        masterViewController.managedObjectContext = self.managedObjectContext;
    }
    [self.window makeKeyAndVisible];
    
    
    
    // check the user setttings
    
    self.soundEnabled = [[NSUserDefaults standardUserDefaults] objectForKey:kSoundEnabledKey];
    if (self.soundEnabled == nil) {
        self.soundEnabled = @"YES";
        NSDictionary *soundEnabledDict = [NSDictionary dictionaryWithObject:self.soundEnabled
                                                                     forKey:kSoundEnabledKey];
        [[NSUserDefaults standardUserDefaults] registerDefaults:soundEnabledDict];
    }
    
    self.voiceType = [[NSUserDefaults standardUserDefaults] objectForKey:kVoiceTypeKey];
    if (self.voiceType == nil) {
        self.voiceType = @"male";
        NSDictionary *voiceTypeDict = [NSDictionary dictionaryWithObject:self.voiceType
                                                                  forKey:kVoiceTypeKey];
        [[NSUserDefaults standardUserDefaults] registerDefaults:voiceTypeDict];
    }
    
    
    self.selectedThemeRow = [[NSUserDefaults standardUserDefaults] integerForKey:kThemeRowKey];
    
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.soundEnabled forKey:kSoundEnabledKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.voiceType    forKey:kVoiceTypeKey];
    
}

- (void)saveContext
{
    NSLog(@"inside saveContext");

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
    NSLog(@"inside managedObjectContext");

    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SightWordsMD" withExtension:@"momd"];
    
    NSLog(@"modelURL = %@", modelURL);
    
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
/// commented out this section, because copying this huge database is not finishing in time. iOS is shutting the app down on certain devices.
/* 
    NSFileManager *fmngr = [[NSFileManager alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SightWordsMD.sqlite" ofType:nil];

    NSError *error3;
    [fmngr removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/SightWordsMD.sqlite", NSHomeDirectory()] error:&error3];
    
    
    
    NSError *error2;
    if(![fmngr copyItemAtPath:filePath toPath:[NSString stringWithFormat:@"%@/Documents/SightWordsMD.sqlite", NSHomeDirectory()] error:&error2]) {
        // handle the error
        NSLog(@"Error creating the database: %@", [error2 description]);
        
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SightWordsMD.sqlite"];
*/
    NSURL *storeURL = [[NSBundle mainBundle] URLForResource: @"SightWordsMD" withExtension:@"sqlite"];
    NSLog(@"storeUrl = %@", [storeURL description]);
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    if (![fm fileExistsAtPath:[storeURL description]]) {
        NSLog(@"sqlite not found in docs");
    }
    else {
        NSLog(@"sqlite  found in docs");
    }

    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[[NSFileManager alloc] init] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Basic fetching

- (NSArray *)objectsWithEntityName:(NSString *)entityName 
                 matchingPredicate:(NSPredicate *)predicate
                             limit:(NSUInteger)limit
                         batchSize:(NSUInteger)batchSize
                   sortDescriptors:(NSArray *)descriptors
                             error:(NSError **)error {
    
    @try {        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:entityName
                                       inManagedObjectContext:self.managedObjectContext]];
        [request setSortDescriptors:descriptors];
        [request setFetchLimit:limit];
        [request setFetchBatchSize:batchSize];
        [request setPredicate:predicate];
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:error];
        return results;            
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in entity fetch: %@", [exception description]);
        return [NSArray array];
    }
}



#pragma mark - Random

- (UIColor *) cornFlowerBlue
{
    return [UIColor colorWithRed:99.0f/255.0f green:183.0f/255.0f blue:234.0f/255.0f alpha:1.0f];  
}

@end
