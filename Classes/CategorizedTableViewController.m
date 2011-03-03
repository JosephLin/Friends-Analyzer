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

@synthesize property;
@synthesize sortedKeys, userCountsDict;



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

	self.sortedKeys = [[User possibleValuesForCategory:property] valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", property]];
	
    
	self.userCountsDict = [NSMutableDictionary dictionaryWithCapacity:[sortedKeys count]];

    for ( id key in sortedKeys )
    {
        NSNumber* count = [NSNumber numberWithInteger:[User userCountsForKey:property value:key]];
		[userCountsDict setObject:count forKey:key];
    }

    [self.tableView reloadData];
}

- (void)dealloc
{
	[property release];
	[sortedKeys release];
	[userCountsDict release];
	
    [super dealloc];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString* key = [sortedKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;

	NSNumber* count = [userCountsDict objectForKey:key];

	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [count intValue]];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
	GenericTableViewController* childVC = [[GenericTableViewController alloc] init];
	NSString* key = [sortedKeys objectAtIndex:indexPath.row];
	NSArray* users = [User usersForKey:property value:key];
	childVC.userArray = users;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}





@end

