//
//  SignalCell.h
//  Multi Signal Generator
//
//  Created by Robert Miller on 10/14/13.
//  Copyright (c) 2013 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <AVFoundation/AVFoundation.h>

@protocol SignalCellDelegate;

@interface SignalCell : UITableViewCell <UITextFieldDelegate> {
    
    IBOutlet UISlider *volumeSlider;
    IBOutlet UISlider *freqSlider;
    IBOutlet UISegmentedControl *signalType;
    IBOutlet UITextField *freqBox;
    Event *cellSignal;
    AVAudioPlayer *audioPlayer;
    
    NSNumber *signalNumber;
    
}

@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet UISlider *freqSlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *signalType;
@property (nonatomic, retain) NSNumber *signalNumber;
@property (nonatomic, retain) IBOutlet UITextField *freqBox;
@property (nonatomic, retain) Event *cellSignal;
@property (weak, nonatomic) id <SignalCellDelegate> delegate;

-(void)initCell;

-(IBAction)volumeSliderChanged:(id)sender;
-(IBAction)freqSliderChanged:(id)sender;
-(IBAction)freqBoxChanged:(id)sender;
-(IBAction)freqTypeChanged:(id)sender;
-(void)playAudioPlayer:(NSData*)buffer;
-(void)stopAudioPlayer;

@end

@protocol SignalCellDelegate <NSObject>

//-(void)signalCell:(SignalCell*)controller VolumeSliderChanged:(UISlider*)volSlider;

@end
