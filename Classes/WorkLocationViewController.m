//
//  WorkLocationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkLocationViewController.h"
#import "Work.h"
#import "WorkTableViewController.h"


@implementation WorkLocationViewController


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
    self.ownerKeyPath = @"workLocations";
    
    [super viewDidLoad];
}

- (void)createPendingOperations
{
    NSArray* allWorks = [Work allWorks];
    self.total = [allWorks count];
    
    NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:self.total];
    for ( Work* work in allWorks )
    {
        NSString* locationName = work.location;
        id locationGeocode = work.geocodeLocation;
        
        if ( !locationGeocode && locationName )
        {
            //// Has location name but no geocode. ////
            NSOperation* op = [[ForwardGeocodingOperationV2 alloc] initWithQuery:locationName object:work keyPath:@"geocodeLocation"];
            [opArray addObject:op];
        }
    }
    
    self.pendingOperations = [[NSArray alloc] initWithArray:opArray];
}


#pragma mark -
#pragma mark Child View Controller

- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title
{
//    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
//    childVC.workArray = objects;
//    childVC.title = title;
//	[self.navigationController pushViewController:childVC animated:YES];
//	[childVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
    childVC.keyPath = @"geocodeLocation.formatted_address";
    childVC.value = geocode.formatted_address;
    childVC.title = geocode.formatted_address;
	[self.navigationController pushViewController:childVC animated:YES];

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapAnnotation* annotation = view.annotation;
    
    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
    childVC.keyPath = @"geocodeLocation.formatted_address";
    childVC.value = annotation.title;
    childVC.title = annotation.title;
	[self.navigationController pushViewController:childVC animated:YES];
}


@end
