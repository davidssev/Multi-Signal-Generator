//
//  MasterViewController.h
//  Multi Signal Generator
//
//  Created by Robert Miller on 3/27/13.
//  Copyright (c) 2013 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SignalCell.h"

@class DetailViewController;

#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, ADInterstitialAdDelegate, SignalCellDelegate>    {
    
    ADInterstitialAd *upAd;
    AVAudioPlayer *audioPlayer;
    
    float buffer1[44100];
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) ADInterstitialAd *upAd;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSMutableArray *cellArray;

-(IBAction)TestSlider:(id)sender;

@end
