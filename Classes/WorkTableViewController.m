//
//  WorkTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkTableViewController.h"
#import "Work.h"
#import "User.h"


@implementation WorkTableViewController

@synthesize workArray;
@synthesize subtitleStringFormat, subtitleArguments;


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Work* work = [workArray objectAtIndex:indexPath.row];
	cell.textLabel.text = work.user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", work.employer.name, work.start_date, work.location];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark -
#pragma mark Memory management


- (void)dealloc
{
    [workArray release];
    [super dealloc];
}


@end
