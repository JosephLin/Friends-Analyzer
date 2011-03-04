//
//  BirthdayViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorizedTableViewController.h"

typedef enum{
    TableViewSortTypeAge = 0,
    TableViewSortTypeDate,
    TableViewSortTypeHoroscope
} TableViewSortType;


@interface BirthdayViewController : UIViewController
{
    UITableView* tableView;
    UISegmentedControl* segmentedControl;
    NSFetchedResultsController* fetchedResultController;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(TableViewSortType)type;

@end
