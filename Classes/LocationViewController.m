//
//  LocationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "GeocodeTableViewCell.h"


@implementation LocationViewController
@synthesize loadingView;

@synthesize loadingLabel, progressView;
@synthesize tableView, mapView;
@synthesize segmentedControl;
@synthesize fetchedResultsController;
@synthesize ownerKeyPath;
@synthesize pendingOperations;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //// Segmented Control ////
    NSArray* controlItems = @[@"Show Map", @"Show List"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];	
	self.navigationItem.titleView = segmentedControl;
    
    //// Init fetchedResultsController ////
    [self fetchedResultsController];
    
    [self parseLocations];
}

- (void)viewDidUnload
{
    self.loadingView = nil;
    self.loadingLabel = nil;
    self.progressView = nil;
    self.tableView = nil;
    self.mapView = nil;
    self.segmentedControl = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
    [queue removeObserver:self forKeyPath:@"operationCount"];	
    [queue cancelAllOperations];

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark User Interface

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        [self showMapView];
    }
    else
    {
        [self showTableView];
    }
}

- (void)showTableView
{
    if ( ![tableView superview] )
    {
        tableView.frame = self.view.bounds;
        [self.view addSubview:tableView];
    }
    [mapView removeFromSuperview];
}

- (void)showMapView
{
    if ( ![mapView superview] )
    {
        mapView.frame = self.view.bounds;
        [self.view addSubview:mapView];
    }
    [tableView removeFromSuperview];
}

- (void)showLoadingView
{
    if ( ![loadingView superview] )
    {
        loadingView.frame = CGRectMake(0, self.view.bounds.size.height, loadingView.bounds.size.width, loadingView.bounds.size.height);
        [self.view addSubview:loadingView];
        
        [UIView animateWithDuration:0.3 animations:^{
           loadingView.frame = CGRectMake(0, self.view.bounds.size.height - loadingView.bounds.size.height, loadingView.bounds.size.width, loadingView.bounds.size.height);
        }];
    }
}

- (void)hideLoadingView
{
    if ( [loadingView superview] )
    {
        [UIView animateWithDuration:0.3 
                         animations:^{
                             loadingView.frame = CGRectMake(0, self.view.bounds.size.height, loadingView.bounds.size.width, loadingView.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             [loadingView removeFromSuperview];
                         }];
    }
}

- (void)updateViewForProgress
{
    loadingLabel.text = [NSString stringWithFormat:@"Analyzing %d of %d Locations...", total - pending, total];
	progressView.progress = (float)(total - pending) / total;
}

- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title
{
    //// Sub-class should override this. ////
}


#pragma mark -
#pragma mark Geocoding

- (NSOperationQueue*)queue
{
    if ( !queue )
    {
        queue = [NSOperationQueue mainQueue];
        [queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	
        [queue setMaxConcurrentOperationCount:1];
    }
    return queue;
}

- (NSArray*)pendingOperations
{
    //// Sub-class should override this. ////
    return nil;
}

- (void)parseLocations
{
    if ( [self.pendingOperations count] )
    {
        loadingLabel.text = @"Analyzing Locations...";
        progressView.progress = 0;
        [self showLoadingView];
        
        if ( queue.operationCount > 0 )
        {
            [queue cancelAllOperations];
        }
        [self.queue addOperations:self.pendingOperations waitUntilFinished:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		pending = [queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:NO];
		
		if ( pending == 0 )
		{
            [[Geocode managedObjectContext] save:nil];
            
            [self performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:NO];
            [self zoomToFitMapAnnotations];
		}
	}
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    GeocodeTableViewCell *cell = (GeocodeTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GeocodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 7.0;
    }
    
    Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.titleLabel.text = geocode.formatted_address;
    
    NSSet* objects = [geocode valueForKeyPath:ownerKeyPath];
    cell.countLabel.text = [NSString stringWithFormat:@"%d", [objects count]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if ( !fetchedResultsController )
    {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[Geocode entity]];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K.@count != 0", ownerKeyPath];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor* sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES];
        NSSortDescriptor* sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_1" ascending:YES];
        NSSortDescriptor* sortDescriptor3 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_2" ascending:YES];
        NSSortDescriptor* sortDescriptor4 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_3" ascending:YES];
        NSSortDescriptor* sortDescriptor5 = [NSSortDescriptor sortDescriptorWithKey:@"locality" ascending:YES];
        NSSortDescriptor* sortDescriptor6 = [NSSortDescriptor sortDescriptorWithKey:@"sublocality" ascending:YES];
        
        NSArray* sortDescriptors = @[sortDescriptor1, sortDescriptor2, sortDescriptor3, sortDescriptor4, sortDescriptor5, sortDescriptor6];                
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:[Geocode managedObjectContext]
                                                                        sectionNameKeyPath:@"country"
                                                                                 cacheName:nil];
        fetchedResultsController.delegate = self;

        
        NSError* error;
        BOOL success = [fetchedResultsController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
        
        
        //// Add annotations to map view. ////
        [mapView removeAnnotations:mapView.annotations];
        NSArray* annotations = [self mapAnnotationsFromArray:[fetchedResultsController fetchedObjects]];
        [mapView addAnnotations:annotations];
        
        [self zoomToFitMapAnnotations];
    }
    
    return fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
            //// Add annotations to map view. ////
            Geocode* geocode = [fetchedResultsController objectAtIndexPath:newIndexPath];
            MapAnnotation* annotation = [self mapAnnotationFromGeocode:geocode];
            [mapView addAnnotation:annotation];
        }
            break;
            
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
            //// Add annotations to map view. ////
            Geocode* geocode = [fetchedResultsController objectAtIndexPath:indexPath];
            MapAnnotation* annotation = [self mapAnnotationFromGeocode:geocode];
            [mapView addAnnotation:annotation];
        }
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark -
#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
	
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    pin.annotation = annotation;
    
    return pin;
}

- (MapAnnotation*)mapAnnotationFromGeocode:(Geocode*)geocode
{
    MapAnnotation* annotation = [[MapAnnotation alloc] init];
    annotation.coordinate = [geocode coordinate];
    annotation.formattedAddress = geocode.formatted_address;
    annotation.owners = [geocode valueForKeyPath:ownerKeyPath];
    
    return annotation;
}

- (NSArray*)mapAnnotationsFromArray:(NSArray*)geocodes
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[geocodes count]];
    
    for ( Geocode* geocode in geocodes )
    {
        MapAnnotation* annotation = [self mapAnnotationFromGeocode:geocode];
        [array addObject:annotation];
    }
    
    NSArray* mapAnnotations = [NSArray arrayWithArray:array];
    return mapAnnotations;
}

- (void)zoomToFitMapAnnotations
{
    if ( [self.mapView.annotations count] )
	{
		CLLocationCoordinate2D topLeftCoordinate;
		topLeftCoordinate.latitude = -90;
		topLeftCoordinate.longitude = 180;
		
		CLLocationCoordinate2D bottomRightCoordinate;
		bottomRightCoordinate.latitude = 90;
		bottomRightCoordinate.longitude = -180;
		
		for ( id <MKAnnotation> annotation in mapView.annotations )
		{
			topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude);
			topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude);
			
			bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude);
			bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude);
		}
		
		MKCoordinateRegion region;
		region.center.latitude = (topLeftCoordinate.latitude + bottomRightCoordinate.latitude) / 2;
		region.center.longitude = (topLeftCoordinate.longitude + bottomRightCoordinate.longitude ) / 2;
		
        // Add a little extra space on the sides
		region.span.latitudeDelta = fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 1.1;
		region.span.longitudeDelta = fabs(topLeftCoordinate.longitude - bottomRightCoordinate.longitude) * 1.1;
        
		region = [mapView regionThatFits:region];
		[mapView setRegion:region animated:YES];
	}
}

@end









