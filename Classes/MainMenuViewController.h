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
#import "AsyncImageOperation.h"


@interface MainMenuViewController : UIViewController <FBSessionDelegate, AsyncImageOperationDelegate>
{
    UIView* headerView;
	UIImageView* profileImageView;
	UILabel* nameLabel;
	UILabel* friendsCountLabel;
    
	UITableView* tableView;
	UILabel* lastUpdatedLabel;
    
    NSOperationQueue* queue;
}

@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* profileImageView;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* friendsCountLabel;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UILabel* lastUpdatedLabel;

@property (nonatomic, retain) NSArray* menuStructureArray;
@property (nonatomic, retain) User* currentUser;

- (void)loadProfileImage;
- (IBAction)refreshButtonTapped:(id)sender;

@end
