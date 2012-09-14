//
//  LocationViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ForwardGeocodingOperationV2.h"
#import "MapAnnotation.h"


@interface LocationViewController : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView* loadingView;
@property (nonatomic, strong) IBOutlet UILabel* loadingLabel;
@property (nonatomic, strong) IBOutlet UIProgressView* progressView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSString* ownerKeyPath;
@property (nonatomic, strong) NSArray* pendingOperations;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pending;

- (void)createPendingOperations;
- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title;

@end
