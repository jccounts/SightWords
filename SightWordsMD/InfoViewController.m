//
//  InfoViewController.m
//  SightWordsMD
//
//  Created by J.C. Counts on 5/8/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import "InfoViewController.h"
#import "AppDelegate.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize delegate;
@synthesize doneButton;
@synthesize navigationBar;

- (IBAction)done {
    NSLog(@"inside done");
        
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [[self navigationController] setToolbarHidden:NO       animated:NO];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController  popViewControllerAnimated:YES];
    [UIView commitAnimations];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationBar.tintColor          = [[AppDelegate delegate] cornFlowerBlue];
    
    
    ///self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.editButtonItem target:self action:([self closeInfo ])];
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)closeInfo
{
    NSLog(@"inside closeInfo");
}

- (void)infoViewControllerDidFinish:(InfoViewController *)controller{
    NSLog(@"inside infoViewControllerDidFinish");
}

@end
