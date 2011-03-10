//
//  ConcentrationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "Education.h"
#import "Concentration.h"

@implementation ConcentrationViewController

@synthesize fetchedResultController;
@synthesize userCountsDict;


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
    
    NSDictionary* dict = [fetchedResultController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [dict objectForKey:@"name"];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d/%02d",
//                                 [user.birthdayMonth integerValue], [user.birthdayDay integerValue]];
    NSLog(@"%@", dict);
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
//    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultController sections] objectAtIndex:section];
//    return [sectionInfo name];
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
//    return sectionIndexTitles;
    return [fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
//    return [sectionIndexTitles indexOfObject:title];
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
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[Concentration entity]];
        
        [fetchRequest setResultType:NSDictionaryResultType];
        [fetchRequest setReturnsDistinctResults:YES];
        [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"name"]];
        
        NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:[Concentration managedObjectContext]
                                                                        sectionNameKeyPath:@"name"
                                                                                 cacheName:nil];
        
        NSError* error;
        BOOL success = [fetchedResultController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }
    return fetchedResultController;
}


@end
