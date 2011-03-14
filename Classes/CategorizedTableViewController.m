//
//  CategorizedTableViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "CategorizedTableViewController.h"
#import "UserTableViewController.h"

@implementation CategorizedTableViewController

@synthesize sortedKeys, userCountsDict;
@synthesize segmentedControl;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{    
    self.navigationItem.titleView = self.segmentedControl;

    [super viewDidLoad];
}

- (void)dealloc
{
	[sortedKeys release];
	[userCountsDict release];
	[segmentedControl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.sortedKeys = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;

	NSNumber* count = [self.userCountsDict objectForKey:key];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [count intValue]];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
	UserTableViewController* childVC = [[UserTableViewController alloc] init];
	childVC.userArray = [self usersForCellAtIndexPath:indexPath];
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


#pragma mark - 
#pragma mark Table View Data Source
//// Subclass should overload these methods ////

- (NSArray*)sortedKeys
{
    return nil;
}

- (NSDictionary*)userCountsDict
{
    return nil;
}

- (NSArray*)usersForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - 
#pragma mark Segmented Control
//// Subclass should overload these methods ////

- (UISegmentedControl*)segmentedControl
{
    if ( !segmentedControl )
    {
        NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
        
        segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return segmentedControl;
}




@end

