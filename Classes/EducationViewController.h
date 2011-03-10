//
//  EducationViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EducationViewController : UITableViewController
{
	NSArray* menuItemArray;
}

@property (nonatomic, retain) NSArray* menuItemArray;

- (NSString*)propertyNameForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
