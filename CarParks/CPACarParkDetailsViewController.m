//
//  CPACarParkDetailsViewController.m
//  CarParks
//
//  Created by Andrew Sage on 02/09/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import "CPACarParkDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CPAAppDelegate.h"

@interface CPACarParkDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *tariffWebView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *updatedAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *spacesLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favouriteBarButtonItem;
@end

@implementation CPACarParkDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Setup the text styles
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    UIFont *normalFont = [UIFont fontWithName:@"Helvetica" size:18.0f];
    
    
    NSMutableParagraphStyle *paragraphStyleCentred = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyleCentred setAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *paragraphStyleJustified = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyleJustified setAlignment:NSTextAlignmentJustified];
    
    
    NSDictionary *textBoldAttributes = @{NSFontAttributeName:boldFont,
                                         NSForegroundColorAttributeName:[UIColor blackColor]};
    
    NSDictionary *textNormalAttributes = @{NSFontAttributeName:normalFont,
                                           NSForegroundColorAttributeName:[UIColor blackColor],
                                           NSParagraphStyleAttributeName:paragraphStyleJustified};
    
    NSMutableAttributedString *spacesAttributedText = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                    attributes:textBoldAttributes];

    
    self.title = self.carPark.name;
    
    if(self.carPark.capacity != self.carPark.capacity) {
        self.spacesLabel.text = @"Closed";
        self.spacesLabel.backgroundColor = [UIColor colorWithRed:0.400 green:0.400 blue:0.400 alpha:1];
        
    } else {
        
        [spacesAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.carPark.freeSpaces] attributes:textBoldAttributes]];
        
        [spacesAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" of %d", (int)self.carPark.capacity] attributes:textNormalAttributes]];
        
        self.spacesLabel.attributedText = spacesAttributedText;
        self.spacesLabel.backgroundColor = self.carPark.occupancyPercentage.doubleValue < 60 ? [UIColor colorWithRed:0.114 green:0.718 blue:0.506 alpha:1] : [UIColor colorWithRed:0.910 green:0.059 blue:0.220 alpha:1];
    }
    
    
    if(self.carPark.favourite) {
        [self.favouriteBarButtonItem setImage:[UIImage imageNamed:@"remove-from-favourites"]];
    } else {
        [self.favouriteBarButtonItem setImage:[UIImage imageNamed:@"add-to-favourites"]];
    }
    self.spacesLabel.textColor = [UIColor whiteColor];
    self.spacesLabel.layer.cornerRadius = 5.0f;
    
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.carPark.updated
                                                          dateStyle:NSDateFormatterLongStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    
    self.updatedAtLabel.text = [NSString stringWithFormat:@"at %@", dateString];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(self.carPark.locationLat.doubleValue, self.carPark.locationLong.doubleValue);
    point.title = self.carPark.name;
    point.subtitle = [NSString stringWithFormat:@"%d spaces", self.carPark.freeSpaces];
    
    [self.mapView addAnnotation:point];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(point.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    
    NSMutableString *html = [NSMutableString stringWithCapacity:0];
    [html appendString:@"<table>"];
    [html appendFormat:@"<tr><th norwap>Tariff</th><td>%@</td></tr>",self.carPark.tariff];
    [html appendFormat:@"<tr><th norwap>Accessibility</th><td></td></tr>"];
    [html appendFormat:@"<tr><th norwap>Opening times</th><td></td></tr>"];
    [html appendFormat:@"<tr><th norwap>Additional info</th><td></td></tr>"];
    [html appendFormat:@"<tr><th norwap>Address</th><td></td></tr>"];
    [html appendFormat:@"<tr><th norwap>Operated by</th><td></td></tr>"];
    [html appendString:@"</table>"];
    
    [self.tariffWebView loadHTMLString:[self embeddedHTMLforText:html] baseURL:nil];
    self.tariffWebView.scrollView.scrollEnabled = YES;

}

- (NSString*)embeddedHTMLforText:(NSString*)text {
    
    NSString *html = [NSString stringWithFormat:@"<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><title>Untitled Document</title><style type=\"text/css\">body {-webkit-user-select:none; background-color: white; color:black; font-family: 'Century Gothic', Arial, 'Arial Unicode MS', Helvetica, Sans-Serif;} th { font-size:75%%; text-align:left;}</style></head><body>%@</body>", text];
    
    return html;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleFavouriteTapped:(id)sender {
    
    CPAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    self.carPark.favourite = !self.carPark.favourite;
    
    if(self.carPark.favourite) {
        [self.favouriteBarButtonItem setImage:[UIImage imageNamed:@"remove-from-favourites"]];
    } else {
        [self.favouriteBarButtonItem setImage:[UIImage imageNamed:@"add-to-favourites"]];
    }
    
    [appDelegate.managedObjectContext save:nil];
    
}

@end
