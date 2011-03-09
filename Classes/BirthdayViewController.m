//
//  BirthdayViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BirthdayViewController.h"
#import "User.h"

#define kAnimationDuration  0.25


@implementation BirthdayViewController

@synthesize tableView, segmentedControl, pickerView;
@synthesize fetchedResultController;
@synthesize sortOptions, currentSortType;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sortOptions = [NSArray arrayWithObjects:@"Age", @"Date", @"Horoscope", nil];

    
    //// Segmented Control ////
    NSArray* controlItems = [NSArray arrayWithObjects:@"List", @"Chart", nil];
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:controlItems] autorelease];
    
	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];	
	self.navigationItem.titleView = segmentedControl;
    
    
    //// 'Sort By' Button ////
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(sortByButtonTapped:)] autorelease];
    
    //// Picker View ////
    self.pickerView = [[[UIPickerView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, self.view.frame.size.height)] autorelease];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    
    
    self.currentSortType = TableViewSortTypeAge;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.segmentedControl = nil;
    self.pickerView = nil;
}

- (void)dealloc
{
    [tableView release];
    [segmentedControl release];
    [pickerView release];
    [fetchedResultController release];
    [sortOptions release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)showPickerView
{
    [self.view addSubview:pickerView];
    tableView.userInteractionEnabled = NO;
    CGRect rect = CGRectMake(0, self.view.bounds.size.height - pickerView.bounds.size.height, 
                             pickerView.bounds.size.width, pickerView.bounds.size.height);
    [UIView animateWithDuration:kAnimationDuration 
                     animations:^{
                         pickerView.frame = rect;
                         tableView.alpha = 0.5;
                     }];
}

- (void)hidePickerView
{
    CGRect rect = CGRectMake(0, self.view.bounds.size.height, pickerView.bounds.size.width, pickerView.bounds.size.height);
    [UIView animateWithDuration:kAnimationDuration 
                     animations:^{
                         pickerView.frame = rect;
                         tableView.alpha = 1.0;
                     } 
                     completion:^(BOOL finished){ 
                         [pickerView removeFromSuperview];
                         tableView.userInteractionEnabled = YES;
                     }];
}

- (void)sortByButtonTapped:(id)sender
{
    if ( [pickerView superview] )
    {
        [self hidePickerView];
        
    }
    else
    {
        [self showPickerView];
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    if ( [pickerView superview] )
    {
        [self hidePickerView];
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidePickerView];
}

- (void)setCurrentSortType:(TableViewSortType)newSortType
{
    currentSortType = newSortType;
    self.fetchedResultController = [self fetchedResultControllerOfType:currentSortType];
    [self.tableView reloadData];
}


#pragma -
#pragma Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;   
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [sortOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentSortType = row;
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
    
    switch (currentSortType)
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
    
    return [controller autorelease];
}




@end





