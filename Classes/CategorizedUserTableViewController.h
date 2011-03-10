//
//  CategorizedUserTableViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategorizedTableViewController.h"


@interface CategorizedUserTableViewController : CategorizedTableViewController
{
    NSString* property;
}

@property (nonatomic, retain) NSString* property;

@end
