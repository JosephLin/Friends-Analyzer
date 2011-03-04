//
//  BirthdayViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirthdayViewController.h"
#import "User.h"




@implementation BirthdayViewController

@synthesize tableView, segmentedControl;
@synthesize fetchedResultController;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray* controlItems = [NSArray arrayWithObjects:@"Age", @"Date", @"Horoscope", nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.segmentedControl = nil;
}

- (void)dealloc
{
    [tableView release];
    [segmentedControl release];
    [fetchedResultController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultController = [self fetchedResultControllerOfType:segmentedControl.selectedSegmentIndex];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    User* user = [fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = user.name;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d/%02d",
                                 [user.birthdayMonth integerValue], [user.birthdayDay integerValue]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultController sections] objectAtIndex:section];
    
    switch (segmentedControl.selectedSegmentIndex)
    {
        case TableViewSortTypeDate:
        {
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            NSString* monthName = [[dateFormatter monthSymbols] objectAtIndex:[[sectionInfo name] integerValue] - 1];
            [dateFormatter release];
            return monthName;
        }
            
        case TableViewSortTypeHoroscope:
            return [sectionInfo name];
            
        default:    // Age
            return [NSString stringWithFormat:@"%@ years old", [sectionInfo name]];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return sectionIndexTitles;
//  return [fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
//  return [fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


#pragma -
#pragma Fetched Result Controller

- (NSFetchedResultsController*)fetchedResultControllerOfType:(TableViewSortType)type
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[User entity]];
    
    NSArray* sortDescriptors = nil;
    NSPredicate* predicate = nil;
    NSString* sectionNameKeyPath = nil;
    switch (type)
    {
        case TableViewSortTypeDate:
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayMonth != 0 AND birthdayDay != 0"];
            
            NSSortDescriptor* monthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayMonth" ascending:YES];
            NSSortDescriptor* daySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayDay" ascending:YES];
            sortDescriptors = [NSArray arrayWithObjects:monthSortDescriptor, daySortDescriptor, nil];
            
            sectionNameKeyPath = @"birthdayMonth";

        }
            break;
            
        case TableViewSortTypeHoroscope:
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayMonth != 0 AND birthdayDay != 0"];

            NSSortDescriptor* signSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"zodiacSymbol" ascending:YES];
            NSSortDescriptor* monthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayMonth" ascending:YES];
            NSSortDescriptor* daySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthdayDay" ascending:YES];
            sortDescriptors = [NSArray arrayWithObjects:signSortDescriptor, monthSortDescriptor, daySortDescriptor, nil];
        
            sectionNameKeyPath = @"zodiacSymbol";
        }
            break;
            
        default:    // Age
        {
            predicate = [NSPredicate predicateWithFormat:@"birthdayYear != 0"];
            
            NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"birthday" ascending:YES];
            sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];

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
    [fetchRequest release];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return controller;
}




@end





