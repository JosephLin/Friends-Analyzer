//
//  ArrayBasedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"


@interface ArrayBasedTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString* property;
	NSArray* sortedKeys;
	NSDictionary* userCountsDict;
    
    UISegmentedControl* segmentedControl;
    UITableView* tableView;
    PieChartView* pieChartView;
}

@property (nonatomic, retain) NSString* property;
@property (nonatomic, retain) NSArray* sortedKeys;
@property (nonatomic, retain) NSDictionary* userCountsDict;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) PieChartView* pieChartView;

@end