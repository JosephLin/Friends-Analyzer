//
//  ConcentrationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "EducationTableViewController.h"


@implementation ConcentrationViewController


- (void)viewDidLoad
{    
    self.entityName = @"Concentration";
    
    [super viewDidLoad];
}

- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSArray* sorted = [object.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray* array = [sorted valueForKeyPath:@"@unionOfObjects.user"];
    
    return array;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    
    EducationTableViewController* childVC = [[EducationTableViewController alloc] init];
    childVC.keyPath = @"concentrations.name";
    childVC.value = object;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}






@end
