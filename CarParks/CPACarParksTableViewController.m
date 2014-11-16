//
//  CPACarParksTableViewController.m
//  CarParks
//
//  Created by Andrew Sage on 20/08/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import "CPAAppDelegate.h"
#import "CarPark.h"
#import "CPACarParksTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CPACarParkDetailsViewController.h"

@interface CPACarParksTableViewController () {
    CLLocationManager *locationManager;
    CLLocation *mCurrentLocation;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentedControl;
@property (nonatomic, strong) NSMutableArray* fetchedRecordsArray;
@end

@implementation CPACarParksTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];

    [self sortCarParks];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [self sortCarParks];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable {
    CPAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate refreshDataFromServer];
    self.fetchedRecordsArray = [appDelegate getAllCarParkRecords];


    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)sortCarParks {
    
    CPAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    
    switch (self.sortSegmentedControl.selectedSegmentIndex) {
        case 0: // A-Z
            self.fetchedRecordsArray = [appDelegate getAllCarParkRecords];

            [self.fetchedRecordsArray sortUsingComparator:^NSComparisonResult(id a, id b) {
                CarPark *firstCarPark = (CarPark*)a;
                CarPark *secondCarPark = (CarPark*)b;
                
                NSString *first = firstCarPark.name;
                NSString *second = secondCarPark.name;
                
                return (NSComparisonResult)[first localizedCaseInsensitiveCompare:second];
            }];
            break;
            
        case 1: // Distance
            self.fetchedRecordsArray = [appDelegate getAllCarParkRecords];

            [self.fetchedRecordsArray sortUsingComparator:^NSComparisonResult(id a, id b) {
                CarPark *firstCarPark = (CarPark*)a;
                CarPark *secondCarPark = (CarPark*)b;
                
                NSNumber *first = firstCarPark.distance;
                NSNumber *second = secondCarPark.distance;
                
                return (NSComparisonResult)[first compare:second];
            }];
            break;
            
        case 2: // Favourites
            self.fetchedRecordsArray = [appDelegate getFavouriteCarParkRecords];
            [self.fetchedRecordsArray sortUsingComparator:^NSComparisonResult(id a, id b) {
                CarPark *firstCarPark = (CarPark*)a;
                CarPark *secondCarPark = (CarPark*)b;
                
                NSString *first = firstCarPark.name;
                NSString *second = secondCarPark.name;
                
                return (NSComparisonResult)[first localizedCaseInsensitiveCompare:second];
            }];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];

}

- (IBAction)sortSegmentChanged:(UISegmentedControl *)sender {
    
    [self sortCarParks];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedRecordsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CarParkCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *spacesLabel = (UILabel*)[cell viewWithTag:2];
    
    
    CarPark *carPark = [self.fetchedRecordsArray objectAtIndex:indexPath.row];
    
    
    nameLabel.text = carPark.name;
    if(carPark.capacity != carPark.capacity) {
        spacesLabel.text = @"Closed";
        spacesLabel.backgroundColor = [UIColor colorWithRed:0.400 green:0.400 blue:0.400 alpha:1];
        
    } else {
        
        spacesLabel.text = [NSString stringWithFormat:@"%d", carPark.freeSpaces];
        spacesLabel.backgroundColor = carPark.occupancyPercentage.doubleValue < 60 ? [UIColor colorWithRed:0.114 green:0.718 blue:0.506 alpha:1] : [UIColor colorWithRed:0.910 green:0.059 blue:0.220 alpha:1];
    }

    spacesLabel.textColor = [UIColor whiteColor];
    spacesLabel.layer.cornerRadius = 5.0f;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"details"]) {
        
        CPACarParkDetailsViewController *controller = (CPACarParkDetailsViewController*)[segue destinationViewController];
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        
        controller.carPark = [self.fetchedRecordsArray objectAtIndex:ip.row];
    }

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    mCurrentLocation = newLocation;
    
    // Re-calculate distances
    for(CarPark *carPark in self.fetchedRecordsArray) {
        
        CLLocationCoordinate2D carParkCoord = CLLocationCoordinate2DMake(carPark.locationLat.doubleValue, carPark.locationLong.doubleValue);
        
        CLLocation *carParkLocation = [[CLLocation alloc] initWithLatitude:carParkCoord.latitude
                                                                 longitude:carParkCoord.longitude];
        
        CLLocationDistance distance = [mCurrentLocation distanceFromLocation:carParkLocation];
        carPark.distance = [NSNumber numberWithInt:distance];
    }
}

@end
