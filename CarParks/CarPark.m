//
//  CarPark.m
//  CarParks
//
//  Created by Andrew Sage on 20/08/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import "CarPark.h"


@implementation CarPark

@dynamic publicID;
@dynamic name;
@dynamic updated;
@dynamic locationLat;
@dynamic locationLong;
@dynamic occupancy;
@dynamic occupancyPercentage;
@dynamic distance;
@dynamic favourite;
@dynamic tariff;

- (double)capacity {
    double occupancy = self.occupancy.doubleValue;
    double occupancyPercentage = self.occupancyPercentage.doubleValue;
    double capacity = (occupancy / occupancyPercentage) * 100;

    return capacity;
}

- (int)freeSpaces {
    double occupancy = self.occupancy.doubleValue;
    double occupancyPercentage = self.occupancyPercentage.doubleValue;
    double capacity = (occupancy / occupancyPercentage) * 100;
    double spaces = (capacity / 100) *  (100 - occupancyPercentage);
    
    return (int)spaces;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *featuresDictionary = [dictionary objectForKey:@"features"];
    
    self.occupancy = [featuresDictionary valueForKey:@"occupancy"];
    
    self.occupancyPercentage = [NSDecimalNumber decimalNumberWithString:[featuresDictionary valueForKey:@"occupancy_percentage"]];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * latNumber = [f numberFromString:[dictionary valueForKey:@"lat"]];
    
    NSNumber * longNumber = [f numberFromString:[dictionary valueForKey:@"long"]];
    
    self.locationLat = latNumber;
    
    self.locationLong = longNumber;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *dateFromString = [dateFormatter dateFromString:[dictionary valueForKey:@"updated"]];
    
    self.updated = dateFromString;
    self.tariff = [featuresDictionary objectForKey:@"tariff"];
}

@end
