//
//  PositionViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PositionViewController.h"
#import "WorkTableViewController.h"


@implementation PositionViewController


- (void)viewDidLoad
{    
    self.entityName = @"Position";
    
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [fetchedResultsController objectAtIndexPath:indexPath];
    
    WorkTableViewController* childVC = [[WorkTableViewController alloc] init];
    childVC.keyPath = @"position.name";
    childVC.value = object.name;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];

}


@end
