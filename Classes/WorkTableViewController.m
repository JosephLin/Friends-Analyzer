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
#import "WorkCell.h"
#import "UserDetailViewController.h"



@implementation WorkTableViewController


- (void)viewDidLoad
{    
    NSArray* controlItems = @[@"Name", @"Employer"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ( self.shouldShowSegmentedControl )
        self.navigationItem.titleView = self.segmentedControl;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WorkCell" bundle:nil] forCellReuseIdentifier:@"WorkCell"];

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
    WorkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell"];
    cell.work = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[self.fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
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
    NSArray* sectionIndexTitles = [[self.fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	Work* work = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    childVC.user = work.user;
    [self.navigationController pushViewController:childVC animated:YES];
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
    [fetchRequest setEntity:[Work entity]];
    
    if ( self.keyPath && self.value )
    {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@", self.keyPath, self.value];
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
