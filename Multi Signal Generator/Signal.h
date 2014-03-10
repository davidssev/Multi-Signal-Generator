//
//  Signal.h
//  Multi Signal Generator
//
//  Created by Robert Miller on 3/2/14.
//  Copyright (c) 2014 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Signal : NSObject    {
    
    AVAudioPlayer * audioPlayer;
    NSMutableArray * data;
    float volume;
    
}

@end
