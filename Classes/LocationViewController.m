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

@synthesize loadingLabel, activityIndicator, progressView;
@synthesize tableView, mapView;
@synthesize fetchedResultController;
@synthesize ownerKeyPath;
@synthesize mapAnnotations;
@synthesize pendingOperations;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //// Segmented Control ////
    NSArray* controlItems = [NSArray arrayWithObjects:@"Show List", @"Show Map", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];	
	self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
    
    [self parseLocations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.loadingLabel = nil;
    self.activityIndicator = nil;
    self.progressView = nil;
    self.tableView = nil;
    self.mapView = nil;
}

- (void)dealloc
{
    [loadingLabel release];
    [activityIndicator release];
    [progressView release];
    [tableView release];
    [mapView release];
    [fetchedResultController release];
    [ownerKeyPath release];
    [mapAnnotations release];
    [queue cancelAllOperations];
    [queue release];
    [super dealloc];
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
        [self showTableView];
    }
    else
    {
        [self showMapView];
    }
}

- (void)showTableView
{
    loadingLabel.hidden = YES;
    [activityIndicator stopAnimating];
    progressView.hidden = YES;

    if ( ![tableView superview] )
    {
        tableView.frame = self.view.bounds;
        [self.view addSubview:tableView];
    }
    [mapView removeFromSuperview];
    [tableView reloadData];
}

- (void)showMapView
{
    loadingLabel.hidden = YES;
    [activityIndicator stopAnimating];
    progressView.hidden = YES;

    if ( ![mapView superview] )
    {
        mapView.frame = self.view.bounds;
        [self.view addSubview:mapView];
    }
    [tableView removeFromSuperview];
    
    [mapView addAnnotations:self.mapAnnotations];
    mapView.delegate = self;
    
    [self zoomToFitMapAnnotations];
}

- (void)updateViewForProgress
{
    loadingLabel.text = [NSString stringWithFormat:@"Analyzing %d of %d Locations...", total - pending, total];
	progressView.progress = (float)(total - pending) / total;
	
//	NSLog(@"pending = %d", pending);
}

- (NSArray*)mapAnnotations
{
    if ( !mapAnnotations )
    {
        NSArray* fetchedObjects = [self.fetchedResultController fetchedObjects];

        NSMutableArray* array = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
        
        for ( Geocode* geocode in fetchedObjects )
        {
            MapAnnotation* annotation = [[MapAnnotation alloc] init];
            annotation.coordinate = [geocode coordinate];
            annotation.title = geocode.formatted_address;
            annotation.owners = [geocode valueForKeyPath:ownerKeyPath];
            
            [array addObject:annotation];
            [annotation release];
        }

        mapAnnotations = [[NSArray alloc] initWithArray:array];
    }
    
    return mapAnnotations;
}

- (void)pushChildViewControllerWithObjects:(NSArray*)objects
{
    //// Sub-class should override this. ////
}


#pragma mark -
#pragma mark Geocoding

- (NSArray*)pendingOperations
{
    //// Sub-class should override this. ////
    return nil;
}

- (void)parseLocations
{
    if ( [self.pendingOperations count] )
    {
        loadingLabel.hidden = NO;
        loadingLabel.text = @"Analyzing Locations...";
        [activityIndicator startAnimating];
        progressView.progress = 0;
        progressView.hidden = NO;
        
        if ( queue )
        {
            [queue cancelAllOperations];
            [queue release];
        }
        queue = [[NSOperationQueue alloc] init];
        [queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	
        
        [queue setMaxConcurrentOperationCount:1];
        [queue addOperations:self.pendingOperations waitUntilFinished:NO];
    }
    else
    {
        [self showTableView];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		pending = [queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:YES];
		
		if ( pending == 0 )
		{
            [[Geocode managedObjectContext] save:nil];

            self.fetchedResultController = nil;
            [self performSelectorOnMainThread:@selector(showTableView) withObject:nil waitUntilDone:YES];
		}
	}
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    GeocodeTableViewCell *cell = (GeocodeTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GeocodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 7.0;
    }
    
    Geocode* geocode = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    
    cell.titleLabel.text = geocode.formatted_address;
    
    NSSet* objects = [geocode valueForKeyPath:ownerKeyPath];
    cell.countLabel.text = [NSString stringWithFormat:@"%d", [objects count]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultController
{
    if ( !fetchedResultController )
    {
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[Geocode entity]];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K.@count != 0", ownerKeyPath];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor* sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES];
        NSSortDescriptor* sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_1" ascending:YES];
        NSSortDescriptor* sortDescriptor3 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_2" ascending:YES];
        NSSortDescriptor* sortDescriptor4 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_3" ascending:YES];
        NSSortDescriptor* sortDescriptor5 = [NSSortDescriptor sortDescriptorWithKey:@"locality" ascending:YES];
        NSSortDescriptor* sortDescriptor6 = [NSSortDescriptor sortDescriptorWithKey:@"sublocality" ascending:YES];
        
        NSArray* sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, sortDescriptor3, sortDescriptor4, sortDescriptor5, sortDescriptor6, nil];                
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:[Geocode managedObjectContext]
                                                                        sectionNameKeyPath:@"country"
                                                                                 cacheName:nil];
        
        NSError* error;
        BOOL success = [fetchedResultController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }
    
    return fetchedResultController;
}


#pragma mark -
#pragma mark MKMapView Delegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
	
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (pin == nil)
    {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    pin.annotation = annotation;
    
    return pin;
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









