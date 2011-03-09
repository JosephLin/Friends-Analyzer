//
//  UserLocationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLocationViewController.h"


@implementation UserLocationViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"LocationViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.locationKeyPath = @"location";
    self.locationGeocodeKeyPath = @"geocodeLocation";
    self.userKeyPath = @"userLocations";
    
    [super viewDidLoad];
}


@end
