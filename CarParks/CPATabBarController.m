//
//  CPATabBarController.m
//  CarParks
//
//  Created by Andrew Sage on 24/09/2014.
//  Copyright (c) 2014 Xoverto. All rights reserved.
//

#import "CPATabBarController.h"

@interface CPATabBarController ()

@end

@implementation CPATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem *tabBarItem = [self.tabBarController.tabBar.items objectAtIndex:0];
    
    UIImage *unselectedImage = [UIImage imageNamed:@"listview-inactive"];
    UIImage *selectedImage = [UIImage imageNamed:@"listview-active"];
    
    [tabBarItem setImage: [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem setSelectedImage: selectedImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
