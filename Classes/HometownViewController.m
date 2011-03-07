//
//  HometownViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HometownViewController.h"
#import "User.h"

@implementation HometownViewController

@synthesize loadingLabel, activityIndicator, progressView;
@synthesize tableView, mapView;
@synthesize fetchedResultController;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //// Segmented Control ////
    NSArray* controlItems = [NSArray arrayWithObjects:@"List", @"Map", nil];
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
}

- (void)updateViewForProgress
{
    loadingLabel.text = [NSString stringWithFormat:@"Analyzing %d of %d Locations...", total - pending, total];
	progressView.progress = (float)(total - pending) / total;
	
	NSLog(@"pending = %d", pending);
}


#pragma mark -
#pragma mark Geocoding

- (void)parseLocations
{
    loadingLabel.hidden = NO;
    loadingLabel.text = @"Analyzing Locations...";
    [activityIndicator startAnimating];
    progressView.progress = 0;
    progressView.hidden = NO;
    
    
    NSArray* allUsers = [User allUsers];
	total = [allUsers count];
	
	if ( queue )
	{
		[queue cancelAllOperations];
		[queue release];
	}
	queue = [[NSOperationQueue alloc] init];
	[queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	
    
	NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:total];
	for ( User* user in allUsers )
	{
        if ( user.hometown )
        {
            ForwardGeocodingOperation* op = [[ForwardGeocodingOperation alloc] initWithQuery:user.hometown 
                                                                                    delegate:nil];
            [opArray addObject:op];
            [op release];
        }
	}
	[queue setMaxConcurrentOperationCount:1];
	[queue addOperations:opArray waitUntilFinished:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		pending = [queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:YES];
		
		if ( pending == 0 )
		{
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
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Geocode* geocode = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = geocode.formatted_address;
    
    cell.detailTextLabel.text;
    
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultController
{
    if ( !fetchedResultController )
    {
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[Geocode entity]];
        
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
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
        
        NSError* error;
        BOOL success = [fetchedResultController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }
    
    return fetchedResultController;
}



@end









