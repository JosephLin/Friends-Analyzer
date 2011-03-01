//
//  MainMenuViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "FacebookClient.h"

@interface MainMenuViewController : UIViewController <FBSessionDelegate>
{
	UIImageView* userImageView;
	UILabel* nameLabel;
	UILabel* friendsCountLabel;
	UITableView* tableView;
	UILabel* lastUpdatedLabel;
}

@property (nonatomic, retain) IBOutlet UIImageView* userImageView;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* friendsCountLabel;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* lastUpdatedLabel;

@property (nonatomic, retain) NSArray* menuStructureArray;
@property (nonatomic, retain) User* currentUser;


@end
