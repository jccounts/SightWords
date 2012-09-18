//
//  SettingsViewController.m
//  SightWordsMD
//
//  Created by J.C. Counts on 5/29/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kLabelKey        = @"labelKey";
static NSString *kSourceKey       = @"sourceKey";
static NSString *kViewKey         = @"viewKey";

static NSString *kBasicKey        = @"Basic";
static NSString *kBoxKey          = @"Box";
static NSString *kBuilderKey      = @"Builder";
static NSString *kChalkboardKey   = @"Chalkboard";
static NSString *kScrollKey       = @"Scroll";

@implementation SettingsViewController

@synthesize tableViewSounds;
@synthesize dataSourceArray;
@synthesize switchSounds;
@synthesize segmentedControlVoices;
@synthesize navigationBar;


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
    
	self.dataSourceArray = [NSArray arrayWithObjects:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Sounds", kSectionTitleKey,
                             @"Sound", kLabelKey,
                             @"Voice", kLabelKey,
                             self.switchSounds, kViewKey,
                             nil],
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Themes",     kSectionTitleKey,
                             @"Basic",      kBasicKey,
                             @"Box",        kBoxKey,
                             @"Builder",    kBuilderKey,
                             @"Chalkboard", kChalkboardKey,
                             @"Scroll",     kScrollKey,
                             nil],
                            
                            nil];

        
    [self.view addSubview:tableViewSounds];
    self.navigationBar.tintColor = [[AppDelegate delegate] cornFlowerBlue];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *soundEnabled   = [defaults objectForKey:@"soundEnabled"];
    
    NSLog(@"soundEnabled = %@", soundEnabled);
    
    if ([soundEnabled isEqualToString:@"NO"]) {
        [switchSounds setOn:NO];
    }
    else {
        [switchSounds setOn:YES];
    }
    
    NSLog(@"appDelegate.voiceType = %@", appDelegate.voiceType);
    
    if ([appDelegate.voiceType isEqualToString:@"male"]) {
        [segmentedControlVoices setSelectedSegmentIndex:0];
    }
    else {
        [segmentedControlVoices setSelectedSegmentIndex:1];
    }

    
    
    NSInteger selectedThemeRowStored        = [defaults integerForKey:@"themeRow"];
    [AppDelegate delegate].selectedThemeRow = [defaults integerForKey:@"themeRow"];
    NSLog(@"selected theme row = %d", selectedThemeRowStored);
    
///    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeSettings
{
    NSLog(@"inside closeSettings");
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSLog(@"numberOfSectionsInTableView = %d", [self.dataSourceArray count]);
    
    return [self.dataSourceArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[self.dataSourceArray objectAtIndex: section] valueForKey:kSectionTitleKey];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 5;
    }
    
    return 1;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = [indexPath section];
    NSLog(@"section = %i", section);
    switch (section) {
        case 0: 
            if ([indexPath row] == 1) {
                return 60.0;
            }
            
            break;
    }
    
    return 50.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	
    NSInteger section = [indexPath section];
    NSLog(@"section = %i", section);
    switch (section) {
        case 0: // First cell in section 1
            
            if ([indexPath row] == 0) {
                static NSString *kDisplayCell_ID = @"DisplayCellID";
                cell = [self.tableViewSounds dequeueReusableCellWithIdentifier:kDisplayCell_ID];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDisplayCell_ID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    // the cell is being recycled, remove old embedded controls
                    UIView *viewToRemove = nil;
                    viewToRemove = [cell.contentView viewWithTag:1];
                    if (viewToRemove)
                        [viewToRemove removeFromSuperview];
                }
                
                cell.textLabel.text = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kLabelKey];
                
                UIControl *control = [[self.dataSourceArray objectAtIndex: indexPath.section] valueForKey:kViewKey];
                [cell.contentView addSubview:control];
            }
            else {
                static NSString *kDisplayCell_ID2 = @"DisplayCellID2";
                cell = [self.tableViewSounds dequeueReusableCellWithIdentifier:kDisplayCell_ID2];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDisplayCell_ID2];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    // the cell is being recycled, remove old embedded controls
                    UIView *viewToRemove = nil;
                    viewToRemove = [cell.contentView viewWithTag:1];
                    if (viewToRemove)
                        [viewToRemove removeFromSuperview];
                }
                
                cell.textLabel.text = @"Voice";
                NSArray *arrayOfImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"male.png"],
                                          [UIImage imageNamed:@"female.png"],
                                          nil];
                
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems: arrayOfImages];
                CGRect frame = CGRectMake(150.0, 10.0, 130.0, 40.0);
                [segmentedControl setFrame:frame];
                [segmentedControl addTarget:self action:@selector(switchVoicesAction:) forControlEvents:UIControlEventValueChanged];
                
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                                
                if ([appDelegate.voiceType isEqualToString:@"male"]) {
                    [segmentedControl setSelectedSegmentIndex:0];
                }
                else {
                    [segmentedControl setSelectedSegmentIndex:1];
                }

                [cell.contentView addSubview:segmentedControl];
            }
            
            break;
            
        case 1: 
            
            if (true)
            {
                static NSString *kDisplayCell_ID = @"DisplayCellID";
                cell = [self.tableViewSounds dequeueReusableCellWithIdentifier:kDisplayCell_ID];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDisplayCell_ID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                else
                {
                    // the cell is being recycled, remove old embedded controls
                    UIView *viewToRemove = nil;
                    viewToRemove = [cell.contentView viewWithTag:1];
                    if (viewToRemove)
                        [viewToRemove removeFromSuperview];
                }
                
                NSDictionary *themes = [self.dataSourceArray objectAtIndex: indexPath.section];
                
                NSString *themeName = @"";
                NSInteger row = [indexPath row];
                NSLog(@"row = %i", row);
                switch (row) {
                    case 0:
                        themeName = [themes objectForKey:kBasicKey];
                        [self checkmarkChecker:cell withRow:0];
                        break;
                        
                    case 1:
                        themeName = [themes objectForKey:kBoxKey];
                        [self checkmarkChecker:cell withRow:1];
                        break;
                        
                    case 2:
                        themeName = [themes objectForKey:kBuilderKey];
                        [self checkmarkChecker:cell withRow:2];
                        break;
                        
                    case 3:
                        themeName = [themes objectForKey:kChalkboardKey];
                        [self checkmarkChecker:cell withRow:3];
                        break;
                    
                    case 4:
                        themeName = [themes objectForKey:kScrollKey];
                        [self checkmarkChecker:cell withRow:4];
                        break;                        
                }
                cell.textLabel.text = themeName;
            }
            
            break;
    }
    
	return cell;
}


- (void)checkmarkChecker:(UITableViewCell *)cell withRow:(NSInteger)row
{
    if (row == [AppDelegate delegate].selectedThemeRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)switchSoundsAction:(id)sender
{
    NSLog(@"switchAction: value = %d", [sender isOn]);    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.soundEnabled = ([sender isOn] ? @"YES" : @"NO");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appDelegate.soundEnabled forKey:@"soundEnabled"];
    [defaults synchronize];
    NSLog(@"Sound Data saved");
}

- (void)switchVoicesAction:(id)sender
{
    NSLog(@"switchVoicesAction: selected segment = %d", [sender selectedSegmentIndex]);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *voice = nil;
    if ([sender selectedSegmentIndex] == 0) {
        voice = @"male";
    }
    else {
        voice = @"female";
    }
    appDelegate.voiceType = voice;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appDelegate.voiceType forKey:@"voiceType"];
    [defaults synchronize];
    NSLog(@"Voice Data saved");
}



#pragma mark -
#pragma mark Lazy creation of controls

- (UISwitch *)switchSounds
{
    if (switchSounds == nil) 
    {
        CGRect frame = CGRectMake(198.0, 12.0, 94.0, 27.0);
        switchSounds = [[UISwitch alloc] initWithFrame:frame];
        [switchSounds addTarget:self action:@selector(switchSoundsAction:) forControlEvents:UIControlEventValueChanged];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        switchSounds.backgroundColor = [UIColor clearColor];
		
		[switchSounds setAccessibilityLabel:NSLocalizedString(@"StandardSwitch", @"")];
		
///		switchSounds.tag = kViewTag;	// tag this view for later so we can remove it from recycled table cells
    }
    return switchSounds;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    if (section == 1) {
        NSLog(@"theme section tapped!");
        NSLog(@"row number = %i", [indexPath row]);
        
        // remove all checkmarks
        [self removeAllCheckmarks:tableView];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // store the selectedRow
        [AppDelegate delegate].selectedThemeRow = [indexPath row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ///[defaults setObject:[NSNumber numberWithInt:self.selectedThemeRow] forKey:@"themeRow"];
        [defaults setInteger:[AppDelegate delegate].selectedThemeRow forKey:@"themeRow"];
        [defaults synchronize];
        
        
        NSLog(@"themerow after storing %@", [NSNumber numberWithInt:[AppDelegate delegate].selectedThemeRow]);
    }
}

- (void) removeAllCheckmarks:(UITableView *)tableView
{
    for (int section = 0; section < [tableView numberOfSections]; section++) {
        for (int row = 0; row < [tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:cellPath];
            //do stuff with 'cell'
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}



@end
