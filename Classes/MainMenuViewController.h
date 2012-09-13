//
//  MainMenuViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "AsyncImageOperation.h"


@interface MainMenuViewController : UIViewController <AsyncImageOperationDelegate, UIActionSheetDelegate>
{
    UIView* headerView;
	UIImageView* profileImageView;
	UILabel* nameLabel;
	UILabel* friendsCountLabel;
    
	UITableView* tableView;
	UILabel* lastUpdatedLabel;
    
    NSOperationQueue* queue;
}

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* friendsCountLabel;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UILabel* lastUpdatedLabel;

@property (nonatomic, strong) NSArray* menuStructureArray;
@property (nonatomic, strong) User* currentUser;

- (void)loadProfileImage;
- (void)facebookLogout;
- (IBAction)refreshButtonTapped:(id)sender;
- (IBAction)logoutButtonTapped:(id)sender;
- (IBAction)debugButtonTapped:(id)sender;

@end
