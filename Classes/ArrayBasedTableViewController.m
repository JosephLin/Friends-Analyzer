//
//  ArrayBasedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/15/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "ArrayBasedTableViewController.h"
#import "UserTableViewController.h"
#import "User.h"

#define kAnimationDuration  0.75


@implementation ArrayBasedTableViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    
    NSArray* controlItems = @[@"Sort By Name", @"Sort By Number"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_pie_chart"]
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self 
                                                                              action:@selector(toggleChartView)];
    
    [super viewDidLoad];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.sortedKeys = nil;
	[self.tableView reloadData];
}

- (void)toggleChartView
{
    if ( [self.pieChartView superview] )
    {
        self.navigationItem.titleView = self.segmentedControl;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_pie_chart"];
        
        [UIView beginAnimations:@"FlipToChart" context:nil];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kAnimationDuration];
        
        [self.pieChartView removeFromSuperview]; 
        
        [UIView commitAnimations];
    }
    else
    {
        self.pieChartView.frame = self.view.bounds;
        
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_table_view"];

        [UIView beginAnimations:@"FlipToChart" context:nil];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kAnimationDuration];
        
        [self.view addSubview:self.pieChartView];
        
        [UIView commitAnimations];
    }
}


- (PieChartView*)pieChartView
{
    if ( !_pieChartView )
    {
        _pieChartView = [[PieChartView alloc] initWithFrame:self.view.bounds];
        _pieChartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_pieChartView setPieChartWithKeys:[self.userCountsDict allKeys] values:[self.userCountsDict allValues]];
    }
    return _pieChartView;
}



#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedKeys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	NSString* key = (self.sortedKeys)[indexPath.row];
    cell.textLabel.text = key;
    
	NSNumber* count = (self.userCountsDict)[key];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [count intValue]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* key = (self.sortedKeys)[indexPath.row];
	NSArray* users = [User usersForKey:self.property value:key];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	NSArray* sorted = [users sortedArrayUsingDescriptors:@[sortDescriptor]];
	
	UserTableViewController* childVC = [[UserTableViewController alloc] init];
	childVC.userArray = sorted;
    childVC.title = key;
	[self.navigationController pushViewController:childVC animated:YES];
}


#pragma mark - 
#pragma mark Table View Data Source
//// Subclass should overload these methods ////

- (NSArray*)sortedKeys
{
    if ( !_sortedKeys )
    {
        NSArray* possibleKeys = [User possibleValuesForCategory:self.property];
        NSString* keyPath = [NSString stringWithFormat:@"@unionOfObjects.%@", self.property];
        NSArray* keys = [possibleKeys valueForKeyPath:keyPath];
        
        if ( self.segmentedControl.selectedSegmentIndex == 0 )
        {
            _sortedKeys = keys;
        }
        else
        {
            _sortedKeys = [keys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
                return [self.userCountsDict[obj1] intValue] < [self.userCountsDict[obj2] intValue];
            }];
        }
    }
    return _sortedKeys;
}

- (NSDictionary*)userCountsDict
{
    if ( !_userCountsDict )
    {
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:[self.sortedKeys count]];
        
        for ( id key in self.sortedKeys )
        {
            NSNumber* count = [NSNumber numberWithInteger:[User userCountsForKey:self.property value:key]];
            tempDict[key] = count;
        }
        
        _userCountsDict = [[NSDictionary alloc] initWithDictionary:tempDict];
    }
    return _userCountsDict;
}







@end


