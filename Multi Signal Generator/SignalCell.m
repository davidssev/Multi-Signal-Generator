//
//  SignalCell.m
//  Multi Signal Generator
//
//  Created by Robert Miller on 10/14/13.
//  Copyright (c) 2013 Robert Miller. All rights reserved.
//

#import "SignalCell.h"

@implementation SignalCell
@synthesize signalNumber,volumeSlider,cellSignal,freqSlider,freqBox;
@synthesize signalType = _signalType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    NSLog(@"signal cell init");
    return self;
}

-(void)initCell {
    NSLog(@"init cell");
    NSLog(@"event signal type: %@",self.cellSignal.signalType);
    
    volumeSlider.value = [cellSignal.volume floatValue];
    freqSlider.value = log10f([cellSignal.frequency floatValue]);
    freqBox.text = [cellSignal.frequency stringValue];
    
    //Set selected segment not set by variable use case statement (Bug in Apple??)
    switch ([cellSignal.signalType intValue]) {
        case 0:
            [self.signalType setSelectedSegmentIndex:0];
            NSLog(@"signal 0");
            break;
        case 1:
            [self.signalType setSelectedSegmentIndex:1];
            NSLog(@"signal 1");
            break;
        case 2:
            [self.signalType setSelectedSegmentIndex:2];
            NSLog(@"signal 2");
            break;
            
        default:
            break;
    }
    
    freqBox.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)volumeSliderChanged:(id)sender   {
    
    //[[self delegate] signalCell:self VolumeSliderChanged:volumeSlider];
    self.cellSignal.volume = [NSNumber numberWithFloat:[volumeSlider value]];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(IBAction)freqSliderChanged:(id)sender {
    
    self.cellSignal.frequency = [NSNumber numberWithFloat:powf(10.0, freqSlider.value)];
    self.freqBox.text = [[NSNumber numberWithFloat:powf(10.0, freqSlider.value)] stringValue];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(IBAction)freqBoxChanged:(id)sender    {
    
    self.cellSignal.frequency = [NSNumber numberWithFloat:[freqBox.text floatValue]];
    self.freqSlider.value = log10f([self.cellSignal.frequency floatValue]);
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(IBAction)freqTypeChanged:(id)sender   {
    
    NSLog(@"freq type changed");
    
    NSLog(@"selected type: %ld",(long)self.signalType.selectedSegmentIndex);
    
    self.cellSignal.signalType = [NSNumber numberWithInteger:self.signalType.selectedSegmentIndex];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(void)playAudioPlayer:(NSData*)buffer  {
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:buffer error:&error];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer play];
    
}

-(void)stopAudioPlayer  {
    
    [audioPlayer stop];
    
}

@end
