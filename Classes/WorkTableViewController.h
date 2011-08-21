//
//  WorkTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkTableViewController : UITableViewController
{
    NSString* keyPath;
    id value;
    
    NSFetchedResultsController* fetchedResultsController;
    UISegmentedControl* segmentedControl;
    
    BOOL shouldShowSegmentedControl;
}

@property (nonatomic, retain) NSString* keyPath;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, assign) BOOL shouldShowSegmentedControl;

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex;

@end
