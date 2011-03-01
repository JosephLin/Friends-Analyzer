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
	NSString* category;
	NSArray* possibleKeys;
	NSMutableDictionary* valueDict;
}

@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSArray* possibleKeys;
@property (nonatomic, retain) NSMutableDictionary* valueDict;

@end
