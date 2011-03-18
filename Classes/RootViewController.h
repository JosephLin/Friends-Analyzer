//
//  RootViewController.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/25/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookClient.h"
#import "User.h"

typedef enum {
	RootViewModeIdle = 0,
	RootViewModeLoadingUserInfo,
	RootViewModeLoadingUserFriends,
	RootViewModeLoadingFriendsInfo
} RootViewMode;

@interface RootViewController : UIViewController <FBSessionDelegate, FBRequestDelegate>
{
	UIButton* loginButton;
	UILabel* loadingLabel;
	UIActivityIndicatorView* activityIndicator;
	UIProgressView* progressView;

	User* currentUser;
	FBRequest* userInfoRequest;
	FBRequest* userFriendsRequest;
	
	NSOperationQueue* queue;
	NSInteger total;
	NSInteger pending;
}

@property (nonatomic, retain) IBOutlet UIButton* loginButton;
@property (nonatomic, retain) IBOutlet UILabel* loadingLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (nonatomic, retain) IBOutlet UIProgressView* progressView;

@property (nonatomic, retain) User* currentUser;
@property (nonatomic, retain) FBRequest* userInfoRequest;
@property (nonatomic, retain) FBRequest* userFriendsRequest;

- (void)updateViewForMode:(RootViewMode)mode;
- (IBAction)loginButtonTapped:(id)sender;
- (void)facebookLogin;
- (void)showMainMenuViewController;
- (void)getUserInfo;

@end
