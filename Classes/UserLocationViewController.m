//
//  UserLocationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLocationViewController.h"
#import "UserTableViewController.h"
#import "User.h"

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
    self.ownerKeyPath = @"userLocations";
    
    [super viewDidLoad];
}

- (NSArray*)pendingOperations
{
    if ( !pendingOperations )
    {
        NSArray* allUsers = [User allUsers];
        total = [allUsers count];
        
        NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:total];
        for ( User* user in allUsers )
        {
            NSString* locationName = user.location;
            id locationGeocode = user.geocodeLocation;
            
            if ( !locationGeocode && locationName )
            {
                //// Has location name but no geocode. ////
                
                ForwardGeocodingOperation* op = [[ForwardGeocodingOperation alloc] initWithQuery:locationName delegate:nil];
                op.object = user;
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

- (void)pushChildViewControllerWithObjects:(NSArray*)objects
{
    UserTableViewController* childVC = [[UserTableViewController alloc] init];
    childVC.userArray = objects;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    Geocode* geocode = [self.fetchedResultController objectAtIndexPath:indexPath];
    NSSet* objects = [geocode valueForKeyPath:ownerKeyPath];
    
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* sortedObjects = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    MapAnnotation* annotation = view.annotation;
    NSArray* sortedObjects = [annotation.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects];
}



@end
