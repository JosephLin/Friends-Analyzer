//
//  ArrayBasedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"


@interface ArrayBasedTableViewController : UITableViewController
{
    NSString* property;
	NSArray* sortedKeys;
	NSMutableDictionary* userCountsDict;
    
    UISegmentedControl* segmentedControl;
    PieChartView* pieChartView;
}

@property (nonatomic, retain) NSString* property;
@property (nonatomic, retain) NSArray* sortedKeys;
@property (nonatomic, retain) NSMutableDictionary* userCountsDict;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, retain) PieChartView* pieChartView;

@end