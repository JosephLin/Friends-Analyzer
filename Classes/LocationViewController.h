//
//  LocationViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ForwardGeocodingOperation.h"


@interface LocationViewController : UIViewController <MKMapViewDelegate>
{
    UILabel* loadingLabel;
    UIActivityIndicatorView* activityIndicator;
    UIProgressView* progressView;
    UITableView* tableView;
    MKMapView* mapView;
    
    NSFetchedResultsController* fetchedResultController;
	NSMutableDictionary* userCountsDict;

	NSOperationQueue* queue;
	NSInteger total;
	NSInteger pending;
}

@property (nonatomic, retain) IBOutlet UILabel* loadingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) NSMutableDictionary* userCountsDict;


- (void)showTableView;
- (void)showMapView;
- (void)parseLocations;
- (void)zoomToFitMapAnnotations;

@end