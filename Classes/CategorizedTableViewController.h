//
//  CategorizedTableViewController.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategorizedTableViewController : UITableViewController
{
	NSArray* sortedKeys;
	NSMutableDictionary* userCountsDict;
    UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) NSArray* sortedKeys;
@property (nonatomic, retain) NSMutableDictionary* userCountsDict;
@property (nonatomic, retain) IBOutlet UISegmentedControl* segmentedControl;

- (NSArray*)usersForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
