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
#import "ForwardGeocodingOperationV2.h"
#import "MapAnnotation.h"


@interface LocationViewController : UIViewController <MKMapViewDelegate>
{
    UILabel* loadingLabel;
    UIProgressView* progressView;
    UITableView* tableView;
    MKMapView* mapView;
    UISegmentedControl* segmentedControl;
    
    NSFetchedResultsController* fetchedResultController;
    NSString* ownerKeyPath;
    
    NSArray* mapAnnotations;

	NSOperationQueue* queue;
	NSInteger total;
	NSInteger pending;
    
    NSArray* pendingOperations;
}

@property (nonatomic, retain) IBOutlet UILabel* loadingLabel;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) NSString* ownerKeyPath;
@property (nonatomic, retain) NSArray* mapAnnotations;
@property (nonatomic, retain) NSArray* pendingOperations;


- (void)showTableView;
- (void)showMapView;
- (void)parseLocations;
- (void)zoomToFitMapAnnotations;
- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title;

@end
