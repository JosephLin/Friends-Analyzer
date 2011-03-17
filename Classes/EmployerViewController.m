//
//  EmployerViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmployerViewController.h"
#import "WorkTableViewController.h"


@implementation EmployerViewController


- (void)viewDidLoad
{    
    self.entityName = @"Employer";
    
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSArray* sorted = [object.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
	childVC.workArray = sorted;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


@end
