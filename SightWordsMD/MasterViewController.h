//
//  MasterViewController.h
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "InfoViewController.h"
#import "SettingsViewController.h"

@class DetailViewController;


@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, InfoViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) UIViewController *infoViewController;
@property (strong, nonatomic) UIViewController *settingsViewController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
