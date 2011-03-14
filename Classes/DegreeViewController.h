//
//  DegreeViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DegreeViewController : UITableViewController
{
    NSFetchedResultsController* fetchedResultController;
    UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex;

@end