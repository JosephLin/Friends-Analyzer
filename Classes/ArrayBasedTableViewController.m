//
//  ArrayBasedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ArrayBasedTableViewController.h"
#import "UserTableViewController.h"
#import "User.h"

#define kAnimationDuration  0.75


@implementation ArrayBasedTableViewController

@synthesize property;
@synthesize sortedKeys, userCountsDict;
@synthesize segmentedControl;
@synthesize tableView, pieChartView;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{    
    self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
    
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:controlItems] autorelease];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Chart" 
																			   style:UIBarButtonItemStylePlain 
																			  target:self 
																			  action:@selector(toggleChartView)] autorelease];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.segmentedControl = nil;
    self.tableView = nil;
    self.pieChartView = nil;
}

- (void)dealloc
{
    [property release];
	[sortedKeys release];
	[userCountsDict release];
	[segmentedControl release];
    [tableView release];
    [pieChartView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.sortedKeys = nil;
	[self.tableView reloadData];
}

- (void)toggleChartView
{
    if ( [pieChartView superview] )
    {
        self.navigationItem.titleView = self.segmentedControl;
        self.navigationItem.rightBarButtonItem.title = @"Chart";
        
        [UIView beginAnimations:@"FlipToChart" context:nil];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:kAnimationDuration];
        
        [pieChartView removeFromSuperview]; 
        
        [UIView commitAnimations];
    }
    else
    {
        self.pieChartView.frame = self.view.bounds;
        
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItem.title = @"Table";

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
    if ( !pieChartView )
    {
        pieChartView = [[PieChartView alloc] initWithFrame:self.view.bounds];
        pieChartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        pieChartView.dict = userCountsDict;
    }
    return pieChartView;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
    cell.textLabel.text = key;
    
	NSNumber* count = [self.userCountsDict objectForKey:key];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [count intValue]];
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
	NSArray* users = [User usersForKey:property value:key];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
	NSArray* sorted = [users sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	UserTableViewController* childVC = [[UserTableViewController alloc] init];
	childVC.userArray = sorted;
    childVC.title = key;
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


#pragma mark - 
#pragma mark Table View Data Source
//// Subclass should overload these methods ////

- (NSArray*)sortedKeys
{
    if ( !sortedKeys )
    {
        NSArray* possibleKeys = [User possibleValuesForCategory:property];
        NSString* keyPath = [NSString stringWithFormat:@"@unionOfObjects.%@", property];
        NSArray* keys = [possibleKeys valueForKeyPath:keyPath];
        
        if ( self.segmentedControl.selectedSegmentIndex == 0 )
        {
            sortedKeys = [keys retain];
        }
        else
        {
            sortedKeys = [[keys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
                return [[userCountsDict objectForKey:obj1] intValue] < [[userCountsDict objectForKey:obj2] intValue];
            }] retain];
        }
    }
    return sortedKeys;
}

- (NSDictionary*)userCountsDict
{
    if ( !userCountsDict )
    {
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:[self.sortedKeys count]];
        
        for ( id key in sortedKeys )
        {
            NSNumber* count = [NSNumber numberWithInteger:[User userCountsForKey:property value:key]];
            [tempDict setObject:count forKey:key];
        }
        
        userCountsDict = [[NSDictionary alloc] initWithDictionary:tempDict];
    }
    return userCountsDict;
}







@end


