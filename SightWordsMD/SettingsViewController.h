//
//  SettingsViewController.h
//  SightWordsMD
//
//  Created by J.C. Counts on 5/29/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableViewSounds;
    UISwitch *switchSounds;
    UISegmentedControl *segmentedControlVoices;
}


@property (nonatomic, retain) IBOutlet UITableView *tableViewSounds;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) NSArray *dataSourceArray;
@property (nonatomic, retain) UISwitch *switchSounds;
@property (nonatomic, retain) UISegmentedControl *segmentedControlVoices;


@end
