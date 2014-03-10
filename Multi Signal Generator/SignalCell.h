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

#define MP3HEADER   44

@interface SignalCell : UITableViewCell <UITextFieldDelegate> {
    
    IBOutlet UISlider *volumeSlider;
    IBOutlet UISlider *freqSlider;
    IBOutlet UISegmentedControl *signalType;
    IBOutlet UITextField *freqBox;
    Event *cellSignal;
    AVAudioPlayer *audioPlayer;
    NSArray * dataArray;
    NSData * buffer;
    //float mp3Array[MP3HEADER];
    float * audioBuffer;
    
    NSNumber *signalNumber;
    
}

@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet UISlider *freqSlider;
@property (nonatomic, retain) IBOutlet UISegmentedControl *signalType;
@property (nonatomic, retain) NSNumber *signalNumber;
@property (nonatomic, retain) IBOutlet UITextField *freqBox;
@property (nonatomic, retain) Event *cellSignal;
@property (nonatomic, retain) NSData * buffer;
@property (weak, nonatomic) id <SignalCellDelegate> delegate;

-(void)initCell;

-(IBAction)volumeSliderChanged:(id)sender;
-(IBAction)freqSliderChanged:(id)sender;
-(IBAction)freqBoxChanged:(id)sender;
-(IBAction)freqTypeChanged:(id)sender;
-(void)playAudioPlayer;
-(void)stopAudioPlayer;
-(IBAction)freqSliderStopped:(id)sender;

@end

@protocol SignalCellDelegate <NSObject>

//-(void)signalCell:(SignalCell*)controller VolumeSliderChanged:(UISlider*)volSlider;

@end
