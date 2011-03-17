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

- (NSArray*)pendingOperations
{
    if ( !pendingOperations )
    {
        NSArray* allWorks = [Work allWorks];
        total = [allWorks count];
        
        NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:total];
        for ( Work* work in allWorks )
        {
            NSString* locationName = work.location;
            id locationGeocode = work.geocodeLocation;
            
            if ( !locationGeocode && locationName )
            {
                //// Has location name but no geocode. ////
                
                ForwardGeocodingOperation* op = [[ForwardGeocodingOperation alloc] initWithQuery:locationName delegate:nil];
                op.object = work;
                op.keyPath = @"geocodeLocation";
                [opArray addObject:op];
                [op release];
            }
        }
        
        pendingOperations = [[NSArray alloc] initWithArray:opArray];
    }
    return pendingOperations;
}


#pragma mark -
#pragma mark Child View Controller

- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title
{
    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
    childVC.workArray = objects;
    childVC.title = title;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    Geocode* geocode = [self.fetchedResultController objectAtIndexPath:indexPath];
    NSSet* objects = [geocode valueForKeyPath:ownerKeyPath];
    
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSArray* sortedObjects = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects title:geocode.formatted_address];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    MapAnnotation* annotation = view.annotation;
    NSArray* sortedObjects = [annotation.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects title:annotation.title];
}


@end
