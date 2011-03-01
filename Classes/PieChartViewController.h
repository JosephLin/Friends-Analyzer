//
//  PieChartViewController.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface PieChartViewController : UIViewController
{
	User* currentUser;
	NSString* category;
}

@property (nonatomic, retain) User* currentUser;
@property (nonatomic, retain) NSString* category;

@end
