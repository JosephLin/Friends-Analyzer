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
//#import "ForwardGeocodingOperationV2.h"
#import "MapAnnotation.h"


@interface LocationViewController : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate>
{
    UIView* loadingView;
    UILabel* loadingLabel;
    UIProgressView* progressView;
    UITableView* tableView;
    MKMapView* mapView;
    UISegmentedControl* segmentedControl;
    
    NSFetchedResultsController* fetchedResultsController;
    NSString* ownerKeyPath;
    
	NSOperationQueue* queue;
	NSInteger total;
	NSInteger pending;
    
    NSArray* pendingOperations;
}

@property (strong, nonatomic) IBOutlet UIView* loadingView;
@property (nonatomic, strong) IBOutlet UILabel* loadingLabel;
@property (nonatomic, strong) IBOutlet UIProgressView* progressView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSString* ownerKeyPath;
@property (nonatomic, strong) NSArray* pendingOperations;


- (void)showTableView;
- (void)showMapView;
- (void)showLoadingView;
- (void)hideLoadingView;
- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title;
- (void)parseLocations;
- (void)zoomToFitMapAnnotations;
- (MapAnnotation*)mapAnnotationFromGeocode:(Geocode*)geocode;
- (NSArray*)mapAnnotationsFromArray:(NSArray*)geocodes;

@end
