//
//  WorkTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "WorkTableViewController.h"
#import "Work.h"
#import "User.h"
#import "WorkTableViewCell.h"
#import "UserDetailViewController.h"



@implementation WorkTableViewController

@synthesize keyPath, value;
@synthesize fetchedResultsController, segmentedControl;
@synthesize shouldShowSegmentedControl;


- (void)viewDidLoad
{    
    NSArray* controlItems = @[@"Name", @"Employer"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ( shouldShowSegmentedControl )
        self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    [super viewDidLoad];
}


- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultsController = [self fetchedResultsControllerOfType:sender.selectedSegmentIndex];    
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;    
}

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
    
    WorkTableViewCell *cell = (WorkTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	Work* work = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.work = work;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    if ( [sectionIndexTitles count] > 10 )
    { 
        return sectionIndexTitles;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index 
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	Work* work = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    childVC.user = work.user;
    [self.navigationController pushViewController:childVC animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if ( !fetchedResultsController)
    {
        fetchedResultsController = [self fetchedResultsControllerOfType:segmentedControl.selectedSegmentIndex];
    }
    return fetchedResultsController;
}

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[Work entity]];
    
    if ( keyPath && value )
    {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@", keyPath, value];
        [fetchRequest setPredicate:predicate];
    }
                              
    NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSSortDescriptor* employerSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"employer.name" ascending:YES];
//    NSSortDescriptor* positionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"position.name" ascending:YES];
    NSSortDescriptor* dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start_date" ascending:NO];
    NSArray* sortDescriptors = nil;
    

    NSString* sectionNameKeyPath = nil;
    
    if ( selectedSegmentIndex == 0 )
    {
        sortDescriptors = @[nameSortDescriptor, employerSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"user.indexTitle";
    }
    else
    {
        sortDescriptors = @[employerSortDescriptor, nameSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"employer.indexTitle";
    }
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                 managedObjectContext:[Work managedObjectContext]
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return controller;
}





@end
