//
//  NameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "NameViewController.h"
#import "User.h"
#import "GenericTableViewController.h"

@implementation NameViewController



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray* controlItems = [NSArray arrayWithObjects:@"Sort By Name", @"Sort By Number", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];

	segmentedControl.selectedSegmentIndex = 0;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    if ( sender.selectedSegmentIndex == 0 )
    {
        self.sortedKeys = [[User possibleValuesForCategory:property] valueForKeyPath:[NSString stringWithFormat:@"@unionOfObjects.%@", property]];
    }
    else
    {
        self.sortedKeys = [sortedKeys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
            return [[userCountsDict objectForKey:obj1] intValue] < [[userCountsDict objectForKey:obj2] intValue];
        }];
    }
    
	[self.tableView reloadData];
}



@end
