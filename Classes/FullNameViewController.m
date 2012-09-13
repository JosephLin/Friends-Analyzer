//
//  FullNameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FullNameViewController.h"
#import "UserDetailViewController.h"
#import "User.h"


@implementation FullNameViewController


- (void)viewDidLoad
{    
    [super viewDidLoad];

    NSArray* controlItems = @[@"Full Name", @"Last Name"];

    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];    
    
    self.navigationItem.titleView = self.segmentedControl;
    
    self.segmentedControl.selectedSegmentIndex = 0;
}


#pragma mark -
#pragma mark Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString* CellIdentifier = @"Cell";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ( self.segmentedControl.selectedSegmentIndex == 0 )
    {
        cell.textLabel.text = user.name;
    }
    else
    {
        if ( user.middle_name )
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@, %@ %@", user.lastName.name, user.middle_name, user.first_name];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", user.lastName.name, user.first_name];
        }
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User* user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
	childVC.user = user;
    childVC.title = user.name;
	[self.navigationController pushViewController:childVC animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[User entity]];
    
    NSSortDescriptor* sortDescriptor = nil;
    NSString* sectionNameKeyPath = nil;
    
    if ( selectedSegmentIndex == 0 )
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        sectionNameKeyPath = @"indexTitle";
    }
    else
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName.name" ascending:YES];
        sectionNameKeyPath = @"lastName.indexTitle";
    }
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                 managedObjectContext:[User managedObjectContext]
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return controller;
}


@end
