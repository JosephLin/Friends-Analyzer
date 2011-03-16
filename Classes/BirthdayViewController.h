//
//  BirthdayViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TableViewSortTypeAge = 0,
    TableViewSortTypeDate,
    TableViewSortTypeHoroscope
} TableViewSortType;


@interface BirthdayViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView* tableView;
    UISegmentedControl* segmentedControl;
    UIPickerView* pickerView;
    NSFetchedResultsController* fetchedResultController;
    
    NSArray* sortOptions;
    TableViewSortType currentSortType;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;
@property (nonatomic, retain) IBOutlet UIPickerView* pickerView;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) NSArray* sortOptions;
@property (nonatomic, assign) TableViewSortType currentSortType;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(TableViewSortType)type;

@end
