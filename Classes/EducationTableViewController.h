//
//  EducationTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EducationTableViewController : UITableViewController
{
    NSString* keyPath;
    id value;
    
    NSFetchedResultsController* fetchedResultController;
    UISegmentedControl* segmentedControl;
    
    BOOL shouldShowSegmentedControl;
}

@property (nonatomic, retain) NSString* keyPath;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, assign) BOOL shouldShowSegmentedControl;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex;

@end