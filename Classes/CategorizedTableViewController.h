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
	NSString* property;
	NSArray* sortedKeys;
	NSMutableDictionary* userCountsDict;
}

@property (nonatomic, retain) NSString* property;
@property (nonatomic, retain) NSArray* sortedKeys;
@property (nonatomic, retain) NSMutableDictionary* userCountsDict;

@end
