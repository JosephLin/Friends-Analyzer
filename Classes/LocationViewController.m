//
//  LocationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "LocationViewController.h"
#import "CounterCell.h"


@interface LocationViewController ()

@property (nonatomic, strong) NSOperationQueue* queue;

@end



@implementation LocationViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //// Segmented Control ////
    NSArray* controlItems = @[@"Show Map", @"Show List"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
	self.segmentedControl.selectedSegmentIndex = 0;
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];	
	self.navigationItem.titleView = self.segmentedControl;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CounterCell" bundle:nil] forCellReuseIdentifier:@"CounterCell"];
    
    //// Init fetchedResultsController ////
    [self fetchedResultsController];

    [self parseLocations];
}

- (void)dealloc
{
    [self.queue removeObserver:self forKeyPath:@"operationCount"];	
    [self.queue cancelAllOperations];
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
    if ( ![self.tableView superview] )
    {
        self.tableView.frame = self.view.bounds;
        [self.view addSubview:self.tableView];
    }
    [self.mapView removeFromSuperview];
}

- (void)showMapView
{
    if ( ![self.mapView superview] )
    {
        self.mapView.frame = self.view.bounds;
        [self.view addSubview:self.mapView];
    }
    [self.tableView removeFromSuperview];
}

- (void)showLoadingView
{
    if ( ![self.loadingView superview] )
    {
        self.loadingView.frame = CGRectMake(0, self.view.bounds.size.height, self.loadingView.bounds.size.width, self.loadingView.bounds.size.height);
        [self.view addSubview:self.loadingView];
        
        [UIView animateWithDuration:0.3 animations:^{
           self.loadingView.frame = CGRectMake(0, self.view.bounds.size.height - self.loadingView.bounds.size.height, self.loadingView.bounds.size.width, self.loadingView.bounds.size.height);
        }];
    }
}

- (void)hideLoadingView
{
    if ( [self.loadingView superview] )
    {
        [UIView animateWithDuration:0.3 
                         animations:^{
                             self.loadingView.frame = CGRectMake(0, self.view.bounds.size.height, self.loadingView.bounds.size.width, self.loadingView.bounds.size.height);
                         }
                         completion:^(BOOL finished){
                             [self.loadingView removeFromSuperview];
                         }];
    }
}

- (void)updateViewForProgress
{
    self.loadingLabel.text = [NSString stringWithFormat:@"Analyzing %d of %d Locations...", self.total - self.pending, self.total];
	self.progressView.progress = (float)(self.total - self.pending) / self.total;
}

- (void)pushChildViewControllerWithObjects:(NSArray*)objects title:(NSString*)title
{
    //// Sub-class should override this. ////
}


#pragma mark -
#pragma mark Geocoding

- (NSOperationQueue*)queue
{
    if ( !_queue )
    {
        _queue = [NSOperationQueue mainQueue];
        [_queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	
        [_queue setMaxConcurrentOperationCount:1];
    }
    return _queue;
}

- (void)createPendingOperations
{
    //// Sub-class should override this. ////
}

- (void)parseLocations
{
    [self createPendingOperations];
    if ( [self.pendingOperations count] )
    {
        self.loadingLabel.text = @"Analyzing Locations...";
        self.progressView.progress = 0;
        [self showLoadingView];
        
        if ( self.queue.operationCount > 0 )
        {
            [self.queue cancelAllOperations];
        }
        [self.queue addOperations:self.pendingOperations waitUntilFinished:NO];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		self.pending = [self.queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:NO];
		
		if ( self.pending == 0 )
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
    CounterCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CounterCell"];
    
    Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:indexPath];    
    cell.titleLabel.text = geocode.formatted_address;
    
    NSSet* objects = [geocode valueForKeyPath:self.ownerKeyPath];
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
    if ( !_fetchedResultsController )
    {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[Geocode entity]];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K.@count != 0", self.ownerKeyPath];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor* sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES];
        NSSortDescriptor* sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_1" ascending:YES];
        NSSortDescriptor* sortDescriptor3 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_2" ascending:YES];
        NSSortDescriptor* sortDescriptor4 = [NSSortDescriptor sortDescriptorWithKey:@"administrative_area_level_3" ascending:YES];
        NSSortDescriptor* sortDescriptor5 = [NSSortDescriptor sortDescriptorWithKey:@"locality" ascending:YES];
        NSSortDescriptor* sortDescriptor6 = [NSSortDescriptor sortDescriptorWithKey:@"sublocality" ascending:YES];
        
        NSArray* sortDescriptors = @[sortDescriptor1, sortDescriptor2, sortDescriptor3, sortDescriptor4, sortDescriptor5, sortDescriptor6];                
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:[Geocode managedObjectContext]
                                                                        sectionNameKeyPath:@"country"
                                                                                 cacheName:nil];
        _fetchedResultsController.delegate = self;

        
        NSError* error;
        BOOL success = [_fetchedResultsController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
        
        
        //// Add annotations to map view. ////
        [self.mapView removeAnnotations:self.mapView.annotations];
        NSArray* annotations = [self mapAnnotationsFromArray:[_fetchedResultsController fetchedObjects]];
        [self.mapView addAnnotations:annotations];
        
        [self zoomToFitMapAnnotations];
    }
    
    return _fetchedResultsController;
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
            Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
            MapAnnotation* annotation = [self mapAnnotationFromGeocode:geocode];
            [self.mapView addAnnotation:annotation];
        }
            break;
            
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
            //// Add annotations to map view. ////
            Geocode* geocode = [self.fetchedResultsController objectAtIndexPath:indexPath];
            MapAnnotation* annotation = [self mapAnnotationFromGeocode:geocode];
            [self.mapView addAnnotation:annotation];
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
	
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
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
    annotation.owners = [geocode valueForKeyPath:self.ownerKeyPath];
    
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
		
		for ( id <MKAnnotation> annotation in self.mapView.annotations )
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
        
        // Apple map doesn't support region larger than 'one' map. This might be an iOS 6 bug.
//		region = [self.mapView regionThatFits:region];
        
        // check for sane span values
        if (region.span.latitudeDelta > 180.0)
            region.span.latitudeDelta = 180.0;
        
        if (region.span.longitudeDelta > 360.0)
            region.span.longitudeDelta = 360.0;
        
        
		[self.mapView setRegion:region animated:YES];
	}
}

@end









