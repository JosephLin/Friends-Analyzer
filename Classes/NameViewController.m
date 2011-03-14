//
//  NameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "NameViewController.h"
#import "User.h"
#import "GenericTableViewController.h"
#import "LastName.h"

@implementation NameViewController



@synthesize sortedKeys;


- (void)viewDidLoad
{    
    NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
    
    [super viewDidLoad];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        NSSortDescriptor* numberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        self.sortedKeys = [sortedKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:numberSortDescriptor]];
    }
    else
    {
        NSSortDescriptor* numberSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"users.@count" ascending:NO];
        self.sortedKeys = [sortedKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:numberSortDescriptor]];
    }
    
	[self.tableView reloadData];
}



#pragma mark - 
#pragma mark Table View Data Source

- (NSArray*)sortedKeys
{
    if ( !sortedKeys )
    {
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[LastName entity]];
        
        NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];
        
        NSError* error = nil;
        NSArray* results = [[LastName managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        sortedKeys = [results retain];
    }
    return sortedKeys;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeys count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    LastName* object = [self.sortedKeys objectAtIndex:indexPath.section];
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [object.users count]];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray* sectionIndexTitles = [self.sortedKeys valueForKeyPath:@"@unionOfObjects.name"];
    return sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray* sectionIndexTitles = [self.sortedKeys valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    LastName* object = [self.sortedKeys objectAtIndex:indexPath.section];
    NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* users = [object.users sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];

    GenericTableViewController* childVC = [[GenericTableViewController alloc] init];
	childVC.userArray = users;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}



@end
