//
//  Event.h
//  Multi Signal Generator
//
//  Created by Robert Miller on 11/2/13.
//  Copyright (c) 2013 Robert Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * tagNumber;
@property (nonatomic, retain) NSNumber * signalType;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * frequency;

@end
