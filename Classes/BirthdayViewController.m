//
//  BirthdayViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirthdayViewController.h"
#import "User.h"

@implementation BirthdayViewController

@synthesize tableView;
@synthesize fetchedResultController;

- (void)dealloc
{
    [tableView release];
    [fetchedResultController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d/%02d/%d", 
                                 [user.birthdayMonth integerValue], [user.birthdayDay integerValue], [user.birthdayYear integerValue]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
//	GenericTableViewController* childVC = [[GenericTableViewController alloc] init];
//	NSString* key = [sortedKeys objectAtIndex:indexPath.row];
//	NSArray* users = [User usersForKey:property value:key];
//	childVC.userArray = users;
//	[self.navigationController pushViewController:childVC animated:YES];
//	[childVC release];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultController
{
    if ( !fetchedResultController )
    {    
        NSManagedObjectContext* context = [User managedObjectContext];
        
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[User entity]];
        
        NSSortDescriptor* yearSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayYear" ascending:YES];
        NSSortDescriptor* monthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayMonth" ascending:YES];
        NSSortDescriptor* daySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayDay" ascending:YES];
        NSArray* sortDescriptors = [NSArray arrayWithObjects:yearSortDescriptor, monthSortDescriptor, daySortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                      managedObjectContext:context
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
        [fetchRequest release];
        
        NSError* error;
        BOOL success = [fetchedResultController performFetch:&error];
        NSLog(@"Fetch successed? %d", success);
    }
    return fetchedResultController;
}




@end





