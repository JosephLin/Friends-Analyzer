//
//  ConcentrationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "Education.h"
#import "Concentration.h"

@implementation ConcentrationViewController

@synthesize sortedKeys;


- (void)viewDidLoad
{    
    NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
    
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl release];
    
    [super viewDidLoad];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        NSSortDescriptor* numberSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.sortedKeys = [sortedKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:numberSortDescriptor]];
    }
    else
    {
        NSSortDescriptor* numberSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"educations.@count" ascending:NO];
        self.sortedKeys = [sortedKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:numberSortDescriptor]];
    }

	[self.tableView reloadData];
}



#pragma mark - 
#pragma mark Table View Data Source

- (NSArray*)sortedKeys
{
    if ( !sortedKeys )
    {
        NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[Concentration entity]];
        
        NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:nameSortDescriptor]];
        
        NSError* error = nil;
        NSArray* results = [[Concentration managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        sortedKeys = [results retain];
    }
    return sortedKeys;
}

//- (NSArray*)usersForCellAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
//	NSArray* concentrations = [Concentration concentrationsForName:key];
//    NSArray* users = [concentrations valueForKeyPath:@"@unionOfObjects.education.user"];
//    
//	return users;
//}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sortedKeys count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Concentration* concentration = [self.sortedKeys objectAtIndex:indexPath.section];
    cell.textLabel.text = concentration.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [concentration.educations count]];

    return cell;
}
/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    //    return sectionIndexTitles;
    return [fetchedResultController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //    NSArray* sectionIndexTitles = [[fetchedResultController sections] valueForKeyPath:@"@unionOfObjects.name"];
    //    return [sectionIndexTitles indexOfObject:title];
    return [fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
}


@end
