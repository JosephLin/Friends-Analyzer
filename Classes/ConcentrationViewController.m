//
//  ConcentrationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
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
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSArray* sorted = [object.owners sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSArray* array = [sorted valueForKeyPath:@"@unionOfObjects.user"];
    
    return array;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    EducationTableViewController* childVC = [[EducationTableViewController alloc] init];
    childVC.keyPath = @"concentrations.name";
    childVC.value = object;
    childVC.title = object.name;
	[self.navigationController pushViewController:childVC animated:YES];
}






@end
