//
//  HometownViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface HometownViewController : UIViewController
{
    UITableView* tableView;
    MKMapView* mapView;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;

@end
