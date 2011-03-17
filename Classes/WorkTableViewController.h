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
	NSArray* workArray;
    NSString* subtitleStringFormat;
    NSArray* subtitleArguments;
    
    UISegmentedControl* segmentedControl;
}

@property (nonatomic, retain) NSArray* workArray;
@property (nonatomic, retain) NSString* subtitleStringFormat;
@property (nonatomic, retain) NSArray* subtitleArguments; 
@property (nonatomic, retain) UISegmentedControl* segmentedControl;

@end
