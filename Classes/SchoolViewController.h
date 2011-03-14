//
//  EducationCategorizedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SchoolViewController : UITableViewController
{
    NSFetchedResultsController* fetchedResultController;
    UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex;

@end
