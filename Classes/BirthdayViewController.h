//
//  BirthdayViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartView.h"


@interface BirthdayViewController : UITableViewController

@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) PieChartView* pieChartView;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) NSArray* monthNameArray;

@end
