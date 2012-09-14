//
//  FRCBasedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectAttribute.h"


@interface FRCBasedTableViewController : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) NSString* entityName;

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex;
- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
