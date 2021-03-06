//
//  LastUpdateViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "LastUpdateViewController.h"
#import "User.h"
#import "NSDate+Utilities.h"


@implementation LastUpdateViewController


- (void)viewDidLoad
{
    self.title = @"Last Updated";
    [super viewDidLoad];
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
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    
    cell.detailTextLabel.text = [user.updated_time stringFromDate];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionTitles = [[self.fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[sectionTitles count]];
    for ( NSString* title in sectionTitles )
    {
        NSString* indexTitle = [User lastUpdateCategoryIndexTitleForString:title];
        [array addObject:indexTitle];
    }
    self.sectionIndexTitles = [NSArray arrayWithArray:array];
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.sectionIndexTitles indexOfObject:title];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if ( !_fetchedResultsController )
    {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[User entity]];
        
        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"updated_time != nil"];
        //    [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_time" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[User managedObjectContext]
                                                                          sectionNameKeyPath:@"lastUpdateCategory"
                                                                                   cacheName:nil];
        
        NSError* error;
        BOOL success = [_fetchedResultsController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }
    
    return _fetchedResultsController;
}


@end
