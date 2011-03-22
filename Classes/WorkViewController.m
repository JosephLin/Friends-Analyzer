//
//  WorkViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WorkViewController.h"
#import "EmployerViewController.h"
#import "PositionViewController.h"
#import "WorkLocationViewController.h"
#import "WorkTableViewController.h"
#import "Work.h"


@implementation WorkViewController

@synthesize menuItemArray;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.menuItemArray = [NSArray arrayWithObjects:@"By Employer", @"By Position", @"By Location", @"List All", nil];
	
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [menuItemArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
    UIViewController* childVC = nil;
    
    switch (indexPath.row)
    {
        case 0:
            childVC = [[EmployerViewController alloc] init];
            break;
            
        case 1:
            childVC = [[PositionViewController alloc] init];
            break;

        case 2:
            childVC = [[WorkLocationViewController alloc] init];
            break;
            
        default:
            childVC = [[WorkTableViewController alloc] init];
            ((WorkTableViewController*)childVC).shouldShowSegmentedControl = YES;
            break;
    }
    
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


@end
