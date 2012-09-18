//
//  DetailViewController.m
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import "DetailViewController.h"
#import "Word.h"
#import "AppDelegate.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface DetailViewController () {
    BOOL _firstTime;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize soundButton;
@synthesize currentWordId;
@synthesize totalWords;
@synthesize theAudio;
@synthesize soundData;
@synthesize themeId;
@synthesize wordList;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    self.themeId = [NSNumber numberWithInt:4];
    NSLog(@"inside configureView");
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad!!!");
    
    _firstTime = YES;
    
    NSManagedObjectContext *context = [[AppDelegate delegate] managedObjectContext]; 
    
    if (context == nil) 
    { 
        context = [[AppDelegate delegate] managedObjectContext]; 
        NSLog(@"After context: %@",  context);
    }
    
    
    NSLog(@"count = %d", [self.wordList count]);
    self.totalWords    = [NSNumber numberWithInt:[self.wordList count]];
   
    self.detailDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    self.detailDescriptionLabel.minimumFontSize = 5.0;
    self.detailDescriptionLabel.text = [[self.wordList objectAtIndex:0] name];
    
    self.currentWordId = [NSNumber numberWithInt:0];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Release any retained subviews of the main view.
    NSLog(@"inside viewDidDisappear");
    [super viewDidDisappear:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Release any retained subviews of the main view.
    NSLog(@"inside viewWillDisappear");
    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillDisappear:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([[[AppDelegate delegate] voiceType] isEqualToString:@"male"]) {
        self.soundData = [[self.wordList objectAtIndex:0] valueForKey:@"soundMale"];
    }
    else {
        self.soundData = [[self.wordList objectAtIndex:0] valueForKey:@"soundFemale"];
    }
    
/*
    if ([[[AppDelegate delegate] soundEnabled] isEqualToString:@"YES"]) {
        UIImage *speakImg = [UIImage imageNamed:@"286-speechbubble.png"];
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithImage:speakImg
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(playSound)];
        
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
    else {
        NSLog(@"clearing rightbarbuttonitem");
        self.navigationItem.rightBarButtonItem = nil;
    }
*/    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    
    // Set the theme
    self.themeId = [NSNumber numberWithInteger:[AppDelegate delegate].selectedThemeRow];
    [self applyTheme];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"inside viewDidappear");

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Sight Words", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


- (void)applyTheme
{
    NSLog(@"inside applyTheme");
    if ([self.themeId integerValue] == 3) {
        // Chalkboard
        self.detailDescriptionLabel.font      = [DetailViewController getChalkFontWithSize:100];
        self.detailDescriptionLabel.textColor = [UIColor whiteColor];
        self.view.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Chalkboard-iPhone.png"]];
    }
    else if ([self.themeId integerValue] == 2) {
        // Blueprint
        self.detailDescriptionLabel.font      = [UIFont fontWithName:@"Noteworthy" size:100];
        self.detailDescriptionLabel.textColor = [UIColor whiteColor];
        self.view.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Blueprint-iPhone.png"]];
    }
    else if ([self.themeId integerValue] == 4) {
        // Scroll
        self.detailDescriptionLabel.font      = [UIFont fontWithName:@"Papyrus" size:100];
        self.detailDescriptionLabel.textColor = [UIColor blackColor];
        self.view.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:@"AgedPaper-iPhone.png"]];
    }
    else if ([self.themeId integerValue] == 1) {
        // Cardboard
        self.detailDescriptionLabel.font      = [UIFont fontWithName:@"Marker Felt" size:100];
        self.detailDescriptionLabel.textColor = [UIColor blackColor];
        self.view.backgroundColor             = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Cardboard-iPhone.png"]];
    }
    else {
        // Plain
        self.detailDescriptionLabel.font      = [UIFont systemFontOfSize:100];
        self.detailDescriptionLabel.textColor = [UIColor blackColor];
        self.view.backgroundColor             = [UIColor whiteColor];
    }
}



- (IBAction)playSound
{
    NSLog(@"inside playSound");
    
    if ([[[AppDelegate delegate] soundEnabled] isEqualToString:@"YES"]) {
        
//        if (_firstTime) {
//            // start spinner
//            [SVProgressHUD show];
//        }
        
        self.theAudio          = [[AVAudioPlayer alloc] initWithData:self.soundData error:NULL];
        
        self.theAudio.volume   = 1.0;
        
        self.theAudio.delegate = self;
        
        [self.theAudio prepareToPlay];
        
//        if (_firstTime) {
//            // stop spinner
//            [SVProgressHUD dismiss];
//            
//            _firstTime = NO;
//        }
        
        [self.theAudio play];
        NSLog(@"Should have been played");
    }
}

- (IBAction)handleSwipeLeft
{
    NSLog(@"inside handleSwipeLeft");
    NSLog(@"self.currentWordId = %@", self.currentWordId);
    NSLog(@"[self.wordList count] = %d", [self.wordList count]);
    
    if ([self.currentWordId intValue] < ([self.wordList count] -1)) {
        NSLog(@"must be less than wordlist count");
        self.detailDescriptionLabel.text = [[self.wordList objectAtIndex:[self.currentWordId intValue] + 1] name];
        self.currentWordId               = [NSNumber numberWithInt:[self.currentWordId intValue] + 1];
        if ([[[AppDelegate delegate] voiceType] isEqualToString:@"male"]) {
            self.soundData = [[self.wordList objectAtIndex:[self.currentWordId intValue]] soundMale];
        }
        else {
            self.soundData = [[self.wordList objectAtIndex:[self.currentWordId intValue]] soundFemale];
        }
    }
}

- (IBAction)handleSwipeRight
{
    NSLog(@"inside handleSwipeRight");
    if ([self.currentWordId intValue] > 0) {
        self.detailDescriptionLabel.text = [[self.wordList objectAtIndex:[self.currentWordId intValue] - 1] name];
        self.currentWordId               = [NSNumber numberWithInt:[self.currentWordId intValue] - 1];
        if ([[[AppDelegate delegate] voiceType] isEqualToString:@"male"]) {
            self.soundData = [[self.wordList objectAtIndex:[self.currentWordId intValue]] soundMale];
        }
        else {
            self.soundData = [[self.wordList objectAtIndex:[self.currentWordId intValue]] soundFemale];
        }
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
	if (flag) {
		NSLog(@"Did finish playing");
	} else {
		NSLog(@"Did NOT finish playing");
	}
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	
	NSLog(@"%@", [error description]);
}


+(UIFont*) getChalkFontWithSize:(int) size {
    if ([[UIFont fontNamesForFamilyName:@"Chalkboard SE"] count] > 0){
        if ([[UIFont fontNamesForFamilyName:@"Chalkboard SE"] containsObject:@"ChalkboardSE-Regular"]){
            return [UIFont fontWithName:@"ChalkboardSE-Regular" size:size];
        }
        else {
            return [[UIFont fontNamesForFamilyName:@"Chalkboard SE"] objectAtIndex:0];
        }
    }
    else {
        return [UIFont systemFontOfSize:size];
    }
}
@end
