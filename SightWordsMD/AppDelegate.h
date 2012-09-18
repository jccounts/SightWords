//
//  AppDelegate.h
//  SightWordsMD  
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *soundEnabled;
@property (strong, nonatomic) NSString *voiceType;
@property (assign, nonatomic) NSInteger selectedThemeRow;


+ (AppDelegate *) delegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


- (NSArray *)objectsWithEntityName:(NSString *)entityName 
                 matchingPredicate:(NSPredicate *)predicate
                             limit:(NSUInteger)limit
                         batchSize:(NSUInteger)batchSize
                   sortDescriptors:(NSArray *)descriptors
                             error:(NSError **)error;

- (UIColor *) cornFlowerBlue;

@end
