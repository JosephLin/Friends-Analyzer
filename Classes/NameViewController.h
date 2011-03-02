//
//  NameViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NameViewController : UIViewController
{
	NSString* property;
	NSArray* sortedKeys;
	NSMutableDictionary* userDict;

	UITableView* tableView;
	UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) NSString* property;
@property (nonatomic, retain) NSArray* sortedKeys;
@property (nonatomic, retain) NSMutableDictionary* userDict;
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UISegmentedControl* segmentedControl;


@end
