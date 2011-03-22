//
//  FRCBasedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FRCBasedTableViewController.h"
#import "UserTableViewController.h"
#import "GeocodeTableViewCell.h"


@implementation FRCBasedTableViewController

@synthesize fetchedResultController;
@synthesize segmentedControl;
@synthesize entityName;


- (void)viewDidLoad
{    
    NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
    
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:controlItems] autorelease];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];    
    
    self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    [super viewDidLoad];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultController = [self fetchedResultControllerOfType:sender.selectedSegmentIndex];    
	[self.tableView reloadData];
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
    if (cell == nil)
    {
        cell = [[[GeocodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    cell.titleLabel.text = object.name;
    cell.countLabel.text = [NSString stringWithFormat:@"%d", [object.ownerCount intValue]];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];

    UserTableViewController* childVC = [[UserTableViewController alloc] init];
	childVC.userArray = [self objectsForRowAtIndexPath:indexPath];
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}

- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //// Sub-class should override this. ////
    return nil;
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex
{
    NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription* entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:[ObjectAttribute managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortDescriptor = nil;
    NSString* sectionNameKeyPath = nil;
    
    if ( selectedSegmentIndex == 0 )
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        sectionNameKeyPath = @"indexTitle";
    }
    else
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"ownerCount" ascending:NO];
        sectionNameKeyPath = nil;
    }
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ownerCount != 0"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                 managedObjectContext:[ObjectAttribute managedObjectContext]
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return [controller autorelease];
}


@end
