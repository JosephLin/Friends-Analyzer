//
//  GenericTableViewController.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserTableViewController : UITableViewController
{
	NSArray* userArray;
}

@property (nonatomic, strong) NSArray* userArray;

@end
