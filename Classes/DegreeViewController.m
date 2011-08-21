//
//  DegreeViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "DegreeViewController.h"
#import "EducationTableViewController.h"


@implementation DegreeViewController


- (void)viewDidLoad
{    
    self.entityName = @"Degree";
    
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [fetchedResultsController objectAtIndexPath:indexPath];
    
    EducationTableViewController* childVC = [[EducationTableViewController alloc] init];
    childVC.keyPath = @"degree.name";
    childVC.value = object.name;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


@end
