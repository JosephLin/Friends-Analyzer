//
//  EducationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "EducationViewController.h"
#import "ConcentrationViewController.h"
#import "DegreeViewController.h"
#import "SchoolViewController.h"
#import "EducationTableViewController.h"




@implementation EducationViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.menuItemArray = @[@"By Concentration", @"By Degree", @"By School", @"List All"];
	
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItemArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.menuItemArray[indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    UIViewController* childVC = nil;
    
    switch (indexPath.row)
    {
        case 0:
            childVC = [[ConcentrationViewController alloc] init];
            break;
            
        case 1:
            childVC = [[DegreeViewController alloc] init];
            break;
            
        case 2:
            childVC = [[SchoolViewController alloc] init];
            break;
            
        default:
            childVC = [[EducationTableViewController alloc] init];
            ((EducationTableViewController*)childVC).shouldShowSegmentedControl = YES;
            break;
    }
    
	[self.navigationController pushViewController:childVC animated:YES];
}





@end
