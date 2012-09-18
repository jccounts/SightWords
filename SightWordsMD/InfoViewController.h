//
//  InfoViewController.h
//  SightWordsMD
//
//  Created by J.C. Counts on 5/8/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MasterViewController.h"


@protocol InfoViewControllerDelegate;

@interface InfoViewController : UIViewController{
	id <InfoViewControllerDelegate> delegate;
}

@property (nonatomic, strong) id <InfoViewControllerDelegate> delegate;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;

- (IBAction)done;

@end


@protocol InfoViewControllerDelegate
- (void)infoViewControllerDidFinish:(InfoViewController *)controller;
@end

