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
    NSFetchedResultsController* fetchedResultsController;
    UISegmentedControl* segmentedControl;
    
    NSString* entityName;
}

@property (nonatomic, retain) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;
@property (nonatomic, retain) NSString* entityName;

- (NSFetchedResultsController*)fetchedResultsControllerOfType:(NSInteger)selectedSegmentIndex;
- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
