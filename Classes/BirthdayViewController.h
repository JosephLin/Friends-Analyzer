//
//  BirthdayViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"


@interface BirthdayViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* tableView;
    UISegmentedControl* segmentedControl;
    PieChartView* pieChartView;
    NSFetchedResultsController* fetchedResultsController;
    NSArray* monthNameArray;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) PieChartView* pieChartView;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSArray* monthNameArray;

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex;
- (NSDictionary*)userCountDict;

@end
