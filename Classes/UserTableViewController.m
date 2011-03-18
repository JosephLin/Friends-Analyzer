//
//  GenericTableViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "UserTableViewController.h"
#import "User.h"
#import "UserDetailViewController.h"


@implementation UserTableViewController

@synthesize userArray;



#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	User* user = [userArray objectAtIndex:indexPath.row];
	cell.textLabel.text = user.name;
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];

    User* user = [userArray objectAtIndex:indexPath.row];

    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    childVC.user = user;
    [self.navigationController pushViewController:childVC animated:YES];
    [childVC release];
}


#pragma mark -
#pragma mark Memory management


- (void)dealloc
{
    [userArray release];
    [super dealloc];
}


@end

