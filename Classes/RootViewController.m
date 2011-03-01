//
//  RootViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/25/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "RootViewController.h"
#import "MainMenuViewController.h"

@implementation RootViewController

@synthesize loginButton, loadingLabel, activityIndicator, progressView;
@synthesize currentUser;
@synthesize userInfoRequest, userFriendsRequest, friendsInfoRequestArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ( [[FacebookClient sharedFacebook] isSessionValid] )
	{
		[self showMainMenuViewController];
	}
	else
	{
		[self updateViewForMode:RootViewModeIdle];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self updateViewForMode:RootViewModeIdle];

	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	self.loginButton = nil;
	self.loadingLabel = nil;
	self.activityIndicator = nil;
	self.progressView = nil;
}

- (void)dealloc
{
	[loginButton release];
	[loadingLabel release];
	[activityIndicator release];
	[progressView release];
	[currentUser release];
	[userInfoRequest release];
	[userFriendsRequest release];
	[friendsInfoRequestArray release];

    [super dealloc];
}

- (void)updateViewForMode:(RootViewMode)mode
{
	switch (mode)
	{
		case RootViewModeLoadingUserInfo:
			loginButton.hidden = YES;
			loadingLabel.hidden = NO;
			loadingLabel.text = @"Loading User Info...";
			[activityIndicator startAnimating];
			progressView.hidden = YES;
			break;
			
		case RootViewModeLoadingUserFriends:
			loginButton.hidden = YES;
			loadingLabel.hidden = NO;
			loadingLabel.text = @"Loading Friends...";
			[activityIndicator startAnimating];
			progressView.hidden = NO;			
			progressView.progress = 0;
			break;
			
		case RootViewModeLoadingFriendsInfo:
			loginButton.hidden = YES;
			loadingLabel.hidden = NO;
			[activityIndicator startAnimating];
			progressView.hidden = NO;			
			break;
			
		default:
			loginButton.hidden = NO;
			loadingLabel.hidden = YES;
			[activityIndicator stopAnimating];
			progressView.hidden = YES;
			break;
	}
}


#pragma mark -
#pragma mark IBAction

- (IBAction)loginButtonTapped:(id)sender
{
	[self facebookLogin];
}


#pragma mark -
#pragma mark Facebook

- (void)facebookLogin
{
	NSArray* permissions = [NSArray arrayWithObjects:@"read_stream", @"user_about_me", @"friends_about_me", @"friends_relationships", 
							@"user_education_history", @"friends_education_history", nil];
	
	[[FacebookClient sharedFacebook] authorize:permissions delegate:self];
}

- (void)getUserInfo
{
	[self updateViewForMode:RootViewModeLoadingUserInfo];
	
	self.userInfoRequest = [[FacebookClient sharedFacebook] requestWithGraphPath:@"me" andDelegate:self];
}

- (void)fetchFriends
{
	[self updateViewForMode:RootViewModeLoadingUserFriends];
	
	self.userFriendsRequest = [[FacebookClient sharedFacebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)parseFriends
{
	self.friendsInfoRequestArray = [NSMutableArray arrayWithCapacity:[self.currentUser.friends count]];
	
	for ( id friend in self.currentUser.friends )
	{
		NSString* friendID = [friend objectForKey:@"id"];
		FBRequest* request = [[FacebookClient sharedFacebook] requestWithGraphPath:friendID andDelegate:self];
		
		[friendsInfoRequestArray addObject:request];
	}
}

- (void)showMainMenuViewController
{
	MainMenuViewController* childVC = [[MainMenuViewController alloc] init];
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin
{
	NSLog(@"did login");
	[[NSUserDefaults standardUserDefaults] setObject:[FacebookClient sharedFacebook].accessToken forKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:[FacebookClient sharedFacebook].expirationDate forKey:@"ExpirationDate"];

	[self getUserInfo];
}

-(void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"did not login");
	[self updateViewForMode:RootViewModeIdle];
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result
{
	if ( request == self.userInfoRequest )
	{
		self.userInfoRequest = nil;

		self.currentUser = [User existingOrNewUserWithDictionary:result];
		NSLog(@"Current User: %@", currentUser);
		
		[[NSUserDefaults standardUserDefaults] setObject:currentUser.id forKey:@"CurrentUserID"];

		[self fetchFriends];
	}
	
	else if ( request == self.userFriendsRequest )
	{
		self.userFriendsRequest = nil;
		
		self.currentUser.friends = [result objectForKey:@"data"];
		
		[self parseFriends];
	}
	
	else if ( [self.friendsInfoRequestArray containsObject:request] )
	{
		[friendsInfoRequestArray removeObject:request];

		[User existingOrNewUserWithDictionary:result];

		NSInteger total = [currentUser.friends count];
		NSInteger pending = [friendsInfoRequestArray count];
		loadingLabel.text = [NSString stringWithFormat:@"Loading %d of %d Friends...", total - pending, total];
		progressView.progress = (float)(total - pending) / total;
		
		if ( pending == 0 )
		{
			self.friendsInfoRequestArray = nil;
			[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdated"];
			[self showMainMenuViewController];
		}
	}
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"FBRequest failed with error: %@", error);
}


@end






