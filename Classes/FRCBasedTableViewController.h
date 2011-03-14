//
//  FRCBasedTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectAttribute.h"


@interface FRCBasedTableViewController : UITableViewController
{
    NSFetchedResultsController* fetchedResultController;
    UISegmentedControl* segmentedControl;
    
    NSString* entityName;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSString* entityName;

- (NSFetchedResultsController*)fetchedResultControllerOfType:(NSInteger)selectedSegmentIndex;
- (NSArray*)usersForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
