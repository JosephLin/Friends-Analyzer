//
//  FRCBasedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FRCBasedTableViewController.h"
#import "UserTableViewController.h"
#import "CounterCell.h"


@implementation FRCBasedTableViewController


- (void)viewDidLoad
{    
    [super viewDidLoad];

    NSArray* controlItems = @[@"Sort By Name", @"Sort By Number"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = self.segmentedControl;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CounterCell" bundle:nil] forCellReuseIdentifier:@"CounterCell"];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultsController = [self fetchedResultsControllerOfType:sender.selectedSegmentIndex];    
	[self.tableView reloadData];
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
    CounterCell *cell = (CounterCell*)[self.tableView dequeueReusableCellWithIdentifier:@"CounterCell"];
    
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = object.name;
    cell.countLabel.text = [NSString stringWithFormat:@"%d", [object.ownerCount intValue]];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[self.fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray* sectionIndexTitles = [[self.fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    UserTableViewController* childVC = [[UserTableViewController alloc] init];
	childVC.userArray = [self objectsForRowAtIndexPath:indexPath];
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
}

- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //// Sub-class should override this. ////
    return nil;
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if ( !_fetchedResultsController)
    {
        _fetchedResultsController = [self fetchedResultsControllerOfType:self.segmentedControl.selectedSegmentIndex];
    }
    return _fetchedResultsController;
}

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
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
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ownerCount != 0"];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                 managedObjectContext:[ObjectAttribute managedObjectContext]
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return controller;
}


@end
