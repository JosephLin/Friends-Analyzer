//
//  SearchResultViewController.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/25/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookClient.h"


@interface SearchResultViewController : UIViewController <FBRequestDelegate>
{
	NSString* searchString;
	NSString* category;
	NSArray* friendArray;
	NSMutableArray* requestArray;
	NSMutableArray* filteredArray;
	
	FBRequest* friendRequest;
	
	UITableView* tableView;
	UILabel* searchLabel;
}

@property (nonatomic, retain) NSString* searchString;
@property (nonatomic, retain) NSString* category;
@property (nonatomic, retain) NSArray* friendArray;
@property (nonatomic, retain) NSMutableArray* requestArray;
@property (nonatomic, retain) NSMutableArray* filteredArray;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* searchLabel;

- (void)fetchFriends;


@end
