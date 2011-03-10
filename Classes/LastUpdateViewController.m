//
//  LastUpdateViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LastUpdateViewController.h"
#import "User.h"
#import "NSDate+Utilities.h"

@implementation LastUpdateViewController

@synthesize tableView, fetchedResultController;



- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.fetchedResultController = nil;
}

- (void)dealloc
{
    [tableView release];
    [fetchedResultController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    
    User* user = [fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    
    cell.detailTextLabel.text = [user.updated_time stringFromDate];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
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
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[User entity]];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"updated_time != nil"];
        //    [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_time" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:[User managedObjectContext]
                                                                        sectionNameKeyPath:@"lastUpdateCategory"
                                                                                 cacheName:nil];
        [fetchRequest release];
        
        NSError* error;
        BOOL success = [fetchedResultController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }

    return fetchedResultController;
}


@end
