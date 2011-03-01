//
//  CategorizedTableViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "CategorizedTableViewController.h"
#import "User.h"
#import "GenericTableViewController.h"

@implementation CategorizedTableViewController

@synthesize category;
@synthesize possibleKeys, valueDict;



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.possibleKeys = [User possibleValuesForCategory:category];
	
	self.valueDict = [NSMutableDictionary dictionary];
	
	if ( [category isEqualToString:@"degree"] )
	{
	}
	else
	{
		for ( id key in possibleKeys)
		{
			NSArray* users = [User usersForKey:category value:key];
			[valueDict setObject:users forKey:key];
		}
	}	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [possibleKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString* key = [possibleKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
	NSArray* users = [valueDict objectForKey:key];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [users count]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
	GenericTableViewController* childVC = [[GenericTableViewController alloc] init];
	NSString* key = [possibleKeys objectAtIndex:indexPath.row];
	NSArray* users = [valueDict objectForKey:key];
	childVC.userArray = users;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}



- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

