//
//  ConcentrationViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConcentrationViewController : UITableViewController
{
    NSArray* sortedKeys;
}

@property (nonatomic, retain) NSArray* sortedKeys;

@end
