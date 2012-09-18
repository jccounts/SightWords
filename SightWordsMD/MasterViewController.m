//
//  MasterViewController.m
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface MasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

@synthesize detailViewController     = _detailViewController;
@synthesize infoViewController       = _infoViewController;
@synthesize settingsViewController   = _settingsViewController;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext     = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"My Sight Words", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)testing
{
    NSLog(@"just a test");
}

- (IBAction)showInfo
{
    NSLog(@"showInfo");
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[self navigationController] setToolbarHidden:YES       animated:NO];
    
    self.infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController"
                                                                   bundle:nil];
    self.infoViewController.view.frame = self.view.frame;
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    
    [self.navigationController pushViewController:self.infoViewController animated:YES];
    [UIView commitAnimations];
}



- (IBAction)displayConfiguration
{
    NSLog(@"displayConfiguration");
    
    self.settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController"
                                                                           bundle:nil];
    [[self navigationController] presentModalViewController:self.settingsViewController animated:YES];
    
    
    
}

- (void)infoViewControllerDidFinish:(InfoViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage  *configurationImage  = [UIImage imageNamed:@"19-gear.png"];
    UIButton *configurationButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [configurationButton setImage:configurationImage
                         forState:UIControlStateNormal];
    configurationButton.frame = CGRectMake(0.0, 0.0, configurationImage.size.width, configurationImage.size.height);

    [configurationButton addTarget:self
                            action:@selector(displayConfiguration)
                  forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self
                   action:@selector(showInfo)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithCustomView:configurationButton],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil],
                             [[UIBarButtonItem alloc] initWithCustomView:infoButton],
                             nil];
    self.toolbarItems = toolbarItems;
    self.navigationController.toolbarHidden = NO;    
    self.navigationController.navigationBar.tintColor = [[AppDelegate delegate] cornFlowerBlue];
    self.navigationController.toolbar.tintColor       = [[AppDelegate delegate] cornFlowerBlue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"numberOfRowsInSection = %d", [[self gradeList] count]);
    return [[self gradeList] count];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"inside tableview cellforrowatindexpath");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"inside didSelectRowAtIndexPath");
    
    NSArray *sections = [self fetchedResultsController].sections;
    int someSection = 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:someSection];
    NSLog(@"section #ofobjects = %d", [sectionInfo numberOfObjects]);
    
    NSLog(@"row to be retrieved: %d", indexPath.row);
    
    
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        self.detailViewController.detailItem = object;
        
        NSInteger gradeNumber = [indexPath row];
        NSLog(@"set grade = %d", gradeNumber);
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"grade = %d", (gradeNumber - 1)];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
                
        NSError *error = nil;  
        [self.fetchedResultsController performFetch:&error]; 
        
        self.detailViewController.wordList = [self.fetchedResultsController fetchedObjects];
        self.detailViewController.currentWordId = 0;
        self.detailViewController.detailDescriptionLabel.text = [[self.detailViewController.wordList objectAtIndex:0] name];
        self.detailViewController.soundData = [[self.detailViewController.wordList objectAtIndex:0]  valueForKey:@"soundMale"];
        
        
        self.detailViewController.title = [[self gradeList] objectAtIndex:gradeNumber];
        
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        self.detailViewController.detailItem = object;
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{    
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    NSLog(@"inside fetchedResultsController");

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES
                                                                    selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"inside configureCell");
    cell.textLabel.text = [[self gradeList] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    
    cell.imageView.image = [UIImage imageNamed:[[self gradeIcons] objectAtIndex:indexPath.row]];
}

- (NSArray *)gradeList
{
    NSArray *theGrades = [[NSArray alloc] initWithObjects:@"Preschool", @"Kindergarten", @"First Grade", @"Second Grade", @"Third Grade", nil];
    
    return theGrades;
}


- (NSArray *)gradeIcons
{
    NSArray *theIcons = [[NSArray alloc] initWithObjects:@"apple.png", @"glue.png", @"pencil.png", @"eraser.png", @"scissors.png", nil];
    
    return theIcons;
}

@end
