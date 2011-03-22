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
    NSFetchedResultsController* fetchedResultController;
    NSArray* monthNameArray;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, retain) PieChartView* pieChartView;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) NSArray* monthNameArray;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex;
- (NSDictionary*)userCountDict;

@end
