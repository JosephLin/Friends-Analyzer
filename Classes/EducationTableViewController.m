//
//  EducationTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EducationTableViewController.h"
#import "Education.h"
#import "User.h"
#import "EducationTableViewCell.h"
#import "UserDetailViewController.h"



@implementation EducationTableViewController

@synthesize keyPath, value;
@synthesize fetchedResultsController, segmentedControl;
@synthesize shouldShowSegmentedControl;


- (void)viewDidLoad
{    
    NSArray* controlItems = @[@"Name", @"School"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if ( shouldShowSegmentedControl )
        self.navigationItem.titleView = segmentedControl;
    
    segmentedControl.selectedSegmentIndex = 0;
    
    [super viewDidLoad];
}


- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    self.fetchedResultsController = [self fetchedResultsControllerOfType:sender.selectedSegmentIndex];    
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;    
}

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
    
    EducationTableViewCell *cell = (EducationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EducationTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
	Education* education = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.education = education;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    if ( [sectionIndexTitles count] > 10 )
    { 
        return sectionIndexTitles;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index 
{
    NSArray* sectionIndexTitles = [[fetchedResultsController sections] valueForKeyPath:@"@unionOfObjects.name"];
    return [sectionIndexTitles indexOfObject:title];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	Education* education = [fetchedResultsController objectAtIndexPath:indexPath];
    
    UserDetailViewController* childVC = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    childVC.user = education.user;
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
    [fetchRequest setEntity:[Education entity]];
    
    if ( keyPath && value )
    {
        if ( [value isKindOfClass:[NSString class]] )
        {        
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like[c] %@", keyPath, value];
            [fetchRequest setPredicate:predicate];
        }
        else if ( [value isKindOfClass:[ObjectAttribute class]] )
        {
            NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY %K == %@", keyPath, ((ObjectAttribute*)value).name];
            [fetchRequest setPredicate:predicate];
        }
    }
    
    NSSortDescriptor* nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSSortDescriptor* schoolSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"school.name" ascending:YES];
//    NSSortDescriptor* degreeSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"degree.name" ascending:YES];
    NSSortDescriptor* dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO];
    NSArray* sortDescriptors = nil;
    
    
    NSString* sectionNameKeyPath = nil;
    
    if ( selectedSegmentIndex == 0 )
    {
        sortDescriptors = @[nameSortDescriptor, schoolSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"user.indexTitle";
    }
    else
    {
        sortDescriptors = @[schoolSortDescriptor, nameSortDescriptor, dateSortDescriptor];
        sectionNameKeyPath = @"school.indexTitle";
    }
    [fetchRequest setSortDescriptors:sortDescriptors];    
    
    NSFetchedResultsController* controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                                                                 managedObjectContext:[Education managedObjectContext]
                                                                                   sectionNameKeyPath:sectionNameKeyPath
                                                                                            cacheName:nil];
    
    NSError* error;
    BOOL success = [controller performFetch:&error];
    NSLog(@"Fetch successed? %d", success);
    
    return controller;
}





@end

