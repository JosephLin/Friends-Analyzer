//
//  HometownViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/9/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "HometownViewController.h"
#import "UserTableViewController.h"
#import "User.h"


@implementation HometownViewController


#pragma mark - View lifecycle

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
    self.ownerKeyPath = @"userHometowns";
    
    [super viewDidLoad];
}

- (void)createPendingOperations
{
    NSArray* allUsers = [User allUsers];
    self.total = [allUsers count];
    
    NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:self.total];
    for ( User* user in allUsers )
    {
        NSString* locationName = user.hometown;
        id locationGeocode = user.geocodeHometown;
        
        if ( !locationGeocode && locationName )
        {
            //// Has location name but no geocode. ////
            
            NSOperation* op = [[ForwardGeocodingOperationV2 alloc] initWithQuery:locationName object:user keyPath:@"geocodeHometown"];
            [opArray addObject:op];
        }
    }
    
    self.pendingOperations = [NSArray arrayWithArray:opArray];
}


#pragma mark -
#pragma mark Child View Controller

- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title
{
    UserTableViewController* childVC = [[UserTableViewController alloc] init];
    childVC.userArray = objects;
    childVC.title = title;
	[self.navigationController pushViewController:childVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSSet* objects = [geocode valueForKeyPath:self.ownerKeyPath];
    
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* sortedObjects = [objects sortedArrayUsingDescriptors:@[sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects title:geocode.formatted_address];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSSortDescriptor* sortdescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    MapAnnotation* annotation = view.annotation;
    NSArray* sortedObjects = [annotation.owners sortedArrayUsingDescriptors:@[sortdescriptor]];
    
    [self pushChildViewControllerWithObjects:sortedObjects title:annotation.title];
}




@end
