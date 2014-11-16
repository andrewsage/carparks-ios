//
//  CarPark.h
//  CarParks
//
//  Created by Andrew Sage on 20/08/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarPark : NSManagedObject

@property (nonatomic, retain) NSString * publicID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * locationLat;
@property (nonatomic, retain) NSNumber * locationLong;
@property (nonatomic, retain) NSNumber * occupancy;
@property (nonatomic, retain) NSNumber * occupancyPercentage;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * tariff;

@property (nonatomic) BOOL favourite;

- (double)capacity;
- (int)freeSpaces;
- (void)updateWithDictionary:(NSDictionary*)dictionary;

@end
