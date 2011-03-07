//
//  HometownViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HometownViewController.h"


@implementation HometownViewController

@synthesize tableView, mapView;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //// Segmented Control ////
    NSArray* controlItems = [NSArray arrayWithObjects:@"List", @"Map", nil];
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:controlItems];
    
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
    self.mapView = nil;
}

- (void)dealloc
{
    [tableView release];
    [mapView release];
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
}

@end









