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
#import "WorkTableViewCell.h"


@implementation WorkTableViewController

@synthesize workArray;
@synthesize subtitleStringFormat, subtitleArguments;
@synthesize segmentedControl;


- (void)viewDidLoad
{    
    NSArray* controlItems = [NSArray arrayWithObjects:@"Name", @"Employer", nil];
    
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:controlItems] autorelease];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    [super viewDidLoad];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSSortDescriptor* employerSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"employer.name" ascending:YES];
    NSSortDescriptor* positionSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"position.name" ascending:YES];
    NSSortDescriptor* dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start_date" ascending:NO];

    NSArray* sortDescriptors;
    
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            sortDescriptors = [NSArray arrayWithObjects:nameSortDescriptor, employerSortDescriptor, dateSortDescriptor, nil];
            break;
            
        case 1:
            sortDescriptors = [NSArray arrayWithObjects:employerSortDescriptor, nameSortDescriptor, dateSortDescriptor, nil];
            break;
            
        case 2:
            sortDescriptors = [NSArray arrayWithObjects:positionSortDescriptor, nameSortDescriptor, employerSortDescriptor, nil];
            break;
            
        default:
            sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nameSortDescriptor, employerSortDescriptor, nil];
            break;
    }
    
	self.workArray = [workArray sortedArrayUsingDescriptors:sortDescriptors];

	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [workArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    WorkTableViewCell *cell = (WorkTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[WorkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	Work* work = [workArray objectAtIndex:indexPath.row];
    cell.work = work;
//	cell.textLabel.text = work.user.name;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", work.employer.name, work.start_date, work.location];
    
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
