//
//  EducationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EducationViewController.h"
#import "User.h"
#import "GenericTableViewController.h"

@implementation EducationViewController

@synthesize menuItemArray;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.menuItemArray = [NSArray arrayWithObjects:@"By Concentration", @"By Degree", @"By School", nil];
	
    [self.tableView reloadData];
}

- (void)dealloc
{
	[menuItemArray release];
	
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItemArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [menuItemArray objectAtIndex:indexPath.row];
    
    return cell;
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



@end
