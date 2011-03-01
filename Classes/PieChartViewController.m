//
//  PieChartViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "PieChartViewController.h"


@implementation PieChartViewController

@synthesize currentUser, category;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setHidesBackButton:NO];
	NSLog(@"%@", self.navigationItem.backBarButtonItem);
	
//	NSArray* allUsers = [User allUsers];
//
//	NSArray* possibleKeys = [allUsers valueForKeyPath:@"@distinctUnionOfArrays.gender"];
//
//	NSLog(@"possibleKeys: %@", possibleKeys);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}




@end
