//
//  CPACarParkDetailsViewController.h
//  CarParks
//
//  Created by Andrew Sage on 02/09/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CarPark.h"


@interface CPACarParkDetailsViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) CarPark *carPark;


@end
