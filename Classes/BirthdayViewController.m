//
//  BirthdayViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirthdayViewController.h"
#import "User.h"
#import "UserDetailViewController.h"

#define kAnimationDuration  0.75



@implementation BirthdayViewController

@synthesize tableView, segmentedControl;
@synthesize pieChartView;
@synthesize fetchedResultsController;
@synthesize monthNameArray;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    self.monthNameArray = [dateFormatter monthSymbols];
    
    NSArray* controlItems = @[@"Age", @"Date", @"Zodiac"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];	
	self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_pie_chart"]
                                                                               style:UIBarButtonItemStyleBordered
																			  target:self 
																			  action:@selector(toggleChartView)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.segmentedControl = nil;
    self.pieChartView = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultsController = [self fetchedResultsControllerOfType:sender.selectedSegmentIndex];    
    [self.tableView reloadData];
    
    if ( segmentedControl.selectedSegmentIndex == 1 )
    {
        [pieChartView setPieChartWithKeys:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"] values:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.numberOfObjects"] displayNames:monthNameArray];
    }
    else
    {
        [pieChartView setPieChartWithKeys:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"] values:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.numberOfObjects"]];
    }
}

- (void)toggleChartView
{
    if ( [pieChartView superview] )
    {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"icon_pie_chart"];
        
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
        if ( segmentedControl.selectedSegmentIndex == 1 )
        {
            [pieChartView setPieChartWithKeys:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"] values:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.numberOfObjects"] displayNames:monthNameArray];
        }
        else
        {
            [pieChartView setPieChartWithKeys:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"] values:[[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.numberOfObjects"]];
        }
        
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
    if ( !pieChartView )
    {
        pieChartView = [[PieChartView alloc] initWithFrame:self.view.bounds];
        pieChartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return pieChartView;
}

- (NSDictionary*)userCountDict
{
    NSArray* sectionIndexTitles = ( segmentedControl.selectedSegmentIndex == 1 )
    ? monthNameArray
    : [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];

    NSArray* counts = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.numberOfObjects"];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:counts forKeys:sectionIndexTitles];
    return dict;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    User* user = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d/%02d",
                                 [user.birthdayMonth integerValue], [user.birthdayDay integerValue]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{ 
    id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
    
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:    // Age
            return [NSString stringWithFormat:@"%@ years old", [sectionInfo name]];

        case 1:     // Date
        {
            NSString* monthName = monthNameArray[[[sectionInfo name] integerValue] - 1];
            return monthName;
        }
            
        default:    // Zodiac
            return [sectionInfo name];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return sectionIndexTitles;
//  return [fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
//  return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User* user = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    childVC.user = user;
    [self.navigationController pushViewController:childVC animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultsController
{
    if ( !fetchedResultsController)
    {
        fetchedResultsController = [self fetchedResultsControllerOfType:segmentedControl.selectedSegmentIndex];
    }
    return fetchedResultsController;
}

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[User entity]];
    
    NSArray* sortDescriptors = nil;
    NSPredicate* predicate = nil;
    NSString* sectionNameKeyPath = nil;
    
    switch ( segmentedControl.selectedSegmentIndex )
    {
        case 1:
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayMonth != 0 AND birthdayDay != 0"];
            
            NSSortDescriptor* monthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayMonth" ascending:YES];
            NSSortDescriptor* daySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayDay" ascending:YES];
            sortDescriptors = @[monthSortDescriptor, daySortDescriptor];
            
            sectionNameKeyPath = @"birthdayMonth";
        }
            break;
            
        case 2:
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayMonth != 0 AND birthdayDay != 0"];

            NSSortDescriptor* signSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"zodiacSymbol" ascending:YES];
            NSSortDescriptor* monthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayMonth" ascending:YES];
            NSSortDescriptor* daySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayDay" ascending:YES];
            sortDescriptors = @[signSortDescriptor, monthSortDescriptor, daySortDescriptor];
        
            sectionNameKeyPath = @"zodiacSymbol";
        }
            break;
            
        default:    // Age
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayYear != 0"];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:YES];
            sortDescriptors = @[sortDescriptor];

            sectionNameKeyPath = @"age";
        }
            break;
    }
    
    
    [fetchRequest setSortDescriptors:sortDescriptors];

    if ( predicate)
    {
        [fetchRequest setPredicate:predicate];
    }
    
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





