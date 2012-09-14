//
//  WorkTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WorkTableViewController : UITableViewController

@property (nonatomic, strong) NSString* keyPath;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, assign) BOOL shouldShowSegmentedControl;

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex;

@end
