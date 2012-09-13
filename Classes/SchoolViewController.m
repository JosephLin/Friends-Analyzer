//
//  EducationCategorizedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchoolViewController.h"
#import "EducationTableViewController.h"


@implementation SchoolViewController


- (void)viewDidLoad
{    
    self.entityName = @"School";
    
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    EducationTableViewController* childVC = [[EducationTableViewController alloc] init];
    childVC.keyPath = @"school.name";
    childVC.value = object.name;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
}



@end
