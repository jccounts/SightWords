//
//  DetailViewController.h
//  SightWordsMD
//
//  Created by J.C. Counts on 5/4/12.
//  Copyright (c) 2012 Tapalope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *soundButton;
@property (strong, nonatomic) NSNumber *currentWordId;
@property (strong, nonatomic) NSNumber *totalWords;
@property (strong, nonatomic) AVAudioPlayer *theAudio;
@property (strong, nonatomic) NSData *soundData;
@property (strong, nonatomic) NSNumber *themeId;
@property (strong, nonatomic) NSArray *wordList;

- (IBAction)playSound;
- (IBAction)handleSwipeLeft;
- (IBAction)handleSwipeRight;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error;

@end
