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
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];

    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
    childVC.keyPath = @"employer.name";
    childVC.value = object.name;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


@end
