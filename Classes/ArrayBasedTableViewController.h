//
//  ArrayBasedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/15/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
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

@property (nonatomic, strong) NSString* property;
@property (nonatomic, strong) NSArray* sortedKeys;
@property (nonatomic, strong) NSDictionary* userCountsDict;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) PieChartView* pieChartView;

@end