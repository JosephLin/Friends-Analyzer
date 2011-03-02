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

@implementation NameViewController

@synthesize property;
@synthesize sortedKeys, userDict;



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSArray* unsortedKeys = [[User allUsers] valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", property]];
	self.sortedKeys = [unsortedKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
		return [obj1 caseInsensitiveCompare:obj2];
	}];
	
	
	self.userDict = [NSMutableDictionary dictionaryWithCapacity:[sortedKeys count]];
	//	
	//	for ( id key in sortedKeys)
	//	{
	//		NSUInteger count = [User userCountsForKey:property value:key];
	//		[userDict setObject:[NSNumber numberWithInt:count] forKey:key];
	//	}
	
	[self.tableView reloadData];
}

- (void)dealloc
{
	[property release];
	[sortedKeys release];
	[userDict release];
	
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
	
	NSNumber* count = [userDict objectForKey:key];
	if ( !count )
	{
		count = [NSNumber numberWithInteger:[User userCountsForKey:property value:key]];
		[userDict setObject:count forKey:key];
	}
	
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
