//
//  SignalCell.m
//  Multi Signal Generator
//
//  Created by Robert Miller on 10/14/13.
//  Copyright (c) 2013 Robert Miller. All rights reserved.
//

#import "SignalCell.h"

@implementation SignalCell
@synthesize signalNumber,volumeSlider,cellSignal,freqSlider,freqBox, buffer;
@synthesize signalType = _signalType;

int bufferSize;

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
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    freqBox.inputAccessoryView = numberToolbar;
    
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
    
    NSError *error;
    //[self fillBuffer];
    [audioPlayer pause];
    [self fillBuffer];
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataWithBuffer] error:&error];
    [audioPlayer prepareToPlay];
    
    freqBox.delegate = self;
    
}

-(void)cancelNumberPad{
    [freqBox resignFirstResponder];
    freqBox.text = [self.cellSignal.frequency stringValue];
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = numberTextField.text;
    [freqBox resignFirstResponder];
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
    
    NSLog(@"in cell volume slider changed");
    //[[self delegate] signalCell:self VolumeSliderChanged:volumeSlider];
    self.cellSignal.volume = [NSNumber numberWithFloat:[volumeSlider value]];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(IBAction)volumeSliderStopped:(id)sender   {
    
    BOOL playFlag = false;
    if ([audioPlayer isPlaying]) {
        playFlag = true;
    }
    
    NSError *error = Nil;
    //[self fillBuffer];
    [audioPlayer pause];
    [self fillBuffer];
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataWithBuffer] error:&error];
    [audioPlayer prepareToPlay];
    if (playFlag) {
        [audioPlayer setNumberOfLoops:-1];
        [audioPlayer play];
    }
    
}

-(IBAction)freqSliderChanged:(id)sender {
    
    self.cellSignal.frequency = [NSNumber numberWithFloat:powf(10.0, freqSlider.value)];
    self.freqBox.text = [[NSNumber numberWithFloat:powf(10.0, freqSlider.value)] stringValue];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
}

-(IBAction)freqSliderStopped:(id)sender {
    
    NSLog(@"freq slider stopped");
    NSError *error;
    
    BOOL playFlag = false;
    if ([audioPlayer isPlaying]) {
        playFlag = true;
    }
    
    //[self fillBuffer];
    [audioPlayer pause];
    [self fillBuffer];
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataWithBuffer] error:&error];
    [audioPlayer prepareToPlay];
    if (playFlag) {
        [audioPlayer setNumberOfLoops:-1];
        [audioPlayer play];
    }
    
}

-(IBAction)freqBoxChanged:(id)sender    {
    
    self.cellSignal.frequency = [NSNumber numberWithFloat:[freqBox.text floatValue]];
    self.freqSlider.value = log10f([self.cellSignal.frequency floatValue]);
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
    BOOL playFlag = false;
    if ([audioPlayer isPlaying]) {
        playFlag = true;
    }
    
    //[self fillBuffer];
    [audioPlayer pause];
    [self fillBuffer];
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataWithBuffer] error:&error];
    [audioPlayer prepareToPlay];
    if (playFlag) {
        [audioPlayer setNumberOfLoops:-1];
        [audioPlayer play];
    }
    
}

-(IBAction)freqTypeChanged:(id)sender   {
    
    NSLog(@"freq type changed in cell");
    
    NSLog(@"selected type: %ld",(long)self.signalType.selectedSegmentIndex);
    
    self.cellSignal.signalType = [NSNumber numberWithInteger:self.signalType.selectedSegmentIndex];
    
    NSError *error = nil;
    if (![self.cellSignal.managedObjectContext save:&error]) {
        
    }
    
    BOOL playFlag = false;
    if ([audioPlayer isPlaying]) {
        playFlag = true;
    }
    
    //[self fillBuffer];
    [audioPlayer pause];
    [self fillBuffer];
    audioPlayer = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:[self dataWithBuffer] error:&error];
    [audioPlayer prepareToPlay];
    if (playFlag) {
        [audioPlayer setNumberOfLoops:-1];
        [audioPlayer play];
    }
    
}

-(void)fillBuffer   {
    
    float freq = [self.cellSignal.frequency floatValue];
    //bufferSize = ceilf(44100*freq/343.2);
    int cycleSize = ceilf(44100/freq)-1;
    //bufferSize = (ceilf(44100 / freq)-1)*10000;
    bufferSize = cycleSize * 10000;
    float frequency = [self.cellSignal.frequency floatValue];
    float volume = [self.cellSignal.volume floatValue];
    //int cycleSize = ceilf(44100 / freq) - 1;
    float fs = 44100;
    
    audioBuffer = nil;
    audioBuffer = (float *)malloc(bufferSize * sizeof(float));
    
    switch ([self.cellSignal.signalType intValue]) {
        case 0:
            for (int j = 0; j < bufferSize-1; j++) {
                audioBuffer[j] = sinf(M_PI*2*frequency*j/44100.0)*volume;
            }
            break;
        case 1:
            for (int i = 0; i < bufferSize; i+=cycleSize) {
                for (int j = i; j < i+(cycleSize/2); j++) {
                    audioBuffer[j] = volume;
                }
                for (int j = i+(cycleSize/2); j < (i+cycleSize); j++) {
                    audioBuffer[j] = 0;
                }
            }
            break;
        case 2:
            for (int j = 0; j < bufferSize; j+=cycleSize) {
                for (int i = j; i < j+(cycleSize/4); i++) {
                    audioBuffer[i] = volume*4*(i-j)*freq/fs;
                }
                for (int i = j+(cycleSize/4); i < j+3*cycleSize/4; i++) {
                    audioBuffer[i] = volume - volume*4*((i-j)-cycleSize/4)*freq/fs;
                }
                for (int i = j+3*cycleSize/4; i < j+cycleSize; i++) {
                    audioBuffer[i] = -volume*2 + volume*4*((i-j)-2*cycleSize/4)*freq/fs;
                }
            }
            
        default:
            break;
    }
    
}

-(NSData *)dataWithBuffer   {
    
    unsigned int payloadSize = bufferSize * sizeof(SInt16);     // byte size of waveform data
    unsigned int wavSize = 44 + payloadSize;                    // total byte size
    
    // Allocate a memory buffer that will hold the WAV header and the
    // waveform bytes.
    SInt8 *wavBuffer = (SInt8 *)malloc(wavSize);
    if (wavBuffer == NULL)
    {
        NSLog(@"Error allocating %u bytes", wavSize);
        //return nil;
    }
    
    // Fake a WAV header.
    SInt8 *header = (SInt8 *)wavBuffer;
    header[0x00] = 'R';
    header[0x01] = 'I';
    header[0x02] = 'F';
    header[0x03] = 'F';
    header[0x08] = 'W';
    header[0x09] = 'A';
    header[0x0A] = 'V';
    header[0x0B] = 'E';
    header[0x0C] = 'f';
    header[0x0D] = 'm';
    header[0x0E] = 't';
    header[0x0F] = ' ';
    header[0x10] = 16;    // size of format chunk (always 16)
    header[0x11] = 0;
    header[0x12] = 0;
    header[0x13] = 0;
    header[0x14] = 1;     // 1 = PCM format
    header[0x15] = 0;
    header[0x16] = 1;     // number of channels
    header[0x17] = 0;
    header[0x18] = 0x44;  // samples per sec (44100)
    header[0x19] = 0xAC;
    header[0x1A] = 0;
    header[0x1B] = 0;
    header[0x1C] = 0x88;  // bytes per sec (88200)
    header[0x1D] = 0x58;
    header[0x1E] = 0x01;
    header[0x1F] = 0;
    header[0x20] = 2;     // block align (bytes per sample)
    header[0x21] = 0;
    header[0x22] = 16;    // bits per sample
    header[0x23] = 0;
    header[0x24] = 'd';
    header[0x25] = 'a';
    header[0x26] = 't';
    header[0x27] = 'a';
    
    *((SInt32 *)(wavBuffer + 0x04)) = payloadSize + 36;   // total chunk size
    *((SInt32 *)(wavBuffer + 0x28)) = payloadSize;        // size of waveform data
    
    // Convert the floating point audio data into signed 16-bit.
    SInt16 *payload = (SInt16 *)(wavBuffer + 44);
    for (int t = 0; t < bufferSize; ++t)
    {
        payload[t] = audioBuffer[t] * 0x7fff;
    }
    
    // Put everything in an NSData object.
    NSData *data = [[NSData alloc] initWithBytesNoCopy:wavBuffer length:wavSize];
    
    return data;
    
}

-(void)playAudioPlayer  {
    
   // NSError *error;
   // audioPlayer = [[AVAudioPlayer alloc] initWithData:buffer error:&error];
    [audioPlayer setNumberOfLoops:-1];
    [audioPlayer play];
    
}

-(void)stopAudioPlayer  {
    
    [audioPlayer stop];
    
}

@end
