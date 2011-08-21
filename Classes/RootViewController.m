//
//  RootViewController.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/25/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "RootViewController.h"
#import "MainMenuViewController.h"
#import "FBRequestOperation.h"


@implementation RootViewController

@synthesize loginButton, loadingLabel, progressView;
@synthesize currentUser;
@synthesize userInfoRequest, userFriendsRequest;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.currentUser = [User currentUser];
    
	if ( currentUser )
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
	self.progressView = nil;
}

- (void)dealloc
{
	[loginButton release];
	[loadingLabel release];
	[progressView release];
	[currentUser release];
	[userInfoRequest release];
	[userFriendsRequest release];
	[queue release];
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
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			progressView.hidden = YES;
			break;
			
		case RootViewModeLoadingUserFriends:
			loginButton.hidden = YES;
			loadingLabel.hidden = NO;
			loadingLabel.text = @"Loading Friends...";
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			progressView.hidden = NO;			
			progressView.progress = 0;
			break;
			
		case RootViewModeLoadingFriendsInfo:
			loginButton.hidden = YES;
			loadingLabel.hidden = NO;
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			progressView.hidden = NO;			
			break;
			
		default:
			loginButton.hidden = NO;
			loadingLabel.hidden = YES;
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			progressView.hidden = YES;
			break;
	}
}

- (void)updateViewForProgress
{
	loadingLabel.text = [NSString stringWithFormat:@"Loading %d of %d Friends...", total - pending, total];
	progressView.progress = (float)(total - pending) / total;
	
	NSLog(@"pending = %d", pending);
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
	NSArray* permissions = [NSArray arrayWithObjects:
							@"user_about_me", @"friends_about_me", 
							@"user_birthday", @"friends_birthday", 
							@"user_education_history", @"friends_education_history",
							@"user_hometown", @"friends_hometown", 
							@"user_location", @"friends_location", 
							@"user_relationships", @"friends_relationships", 
							@"user_work_history", @"friends_work_history",
							@"user_education_history", @"friends_education_history",
							nil];
	
	[[FacebookClient sharedFacebook] authorize:permissions delegate:self];
}

- (void)getUserInfo
{
	[self updateViewForMode:RootViewModeLoadingUserInfo];

    if ( [[FacebookClient sharedFacebook] isSessionValid] )
    {
        self.userInfoRequest = [[FacebookClient sharedFacebook] requestWithGraphPath:@"me" andDelegate:self];
    }
    else
    {
        [self facebookLogin];
    }
}

- (void)fetchFriends
{
	[self updateViewForMode:RootViewModeLoadingUserFriends];
	
	self.userFriendsRequest = [[FacebookClient sharedFacebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}

- (void)parseFriends
{
	total = [self.currentUser.friends count];
	
	if ( queue )
	{
		[queue cancelAllOperations];
		[queue release];
	}
	queue = [[NSOperationQueue alloc] init];
    [queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	

	NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:total];
	for ( id friend in self.currentUser.friends )
	{
		NSString* friendID = [friend objectForKey:@"id"];
		FBRequestOperation* op = [[FBRequestOperation alloc] initWithGraphPath:friendID delegate:nil];
		[opArray addObject:op];
		[op release];
	}
	[queue setMaxConcurrentOperationCount:5];
	[queue addOperations:opArray waitUntilFinished:NO];
}

- (void)showMainMenuViewController
{
	MainMenuViewController* childVC = [[MainMenuViewController alloc] init];
	[self.navigationController pushViewController:childVC animated:YES];
	[childVC release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		pending = [queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:NO];
		
		if ( pending == 0 )
		{
            [[User managedObjectContext] save:nil];
            
            [queue removeObserver:self forKeyPath:@"operationCount"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdated"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelectorOnMainThread:@selector(showMainMenuViewController) withObject:nil waitUntilDone:NO];
		}
	}
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin
{
	NSLog(@"did login");
	[[NSUserDefaults standardUserDefaults] setObject:[FacebookClient sharedFacebook].accessToken forKey:@"AccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:[FacebookClient sharedFacebook].expirationDate forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];

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
        [[NSUserDefaults standardUserDefaults] synchronize];

		[self fetchFriends];
	}
	
	else if ( request == self.userFriendsRequest )
	{
		self.userFriendsRequest = nil;
		
		self.currentUser.friends = [result objectForKey:@"data"];
		
		[self parseFriends];
	}
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    if ( request == self.userInfoRequest )
	{
		self.userInfoRequest = nil;

		NSLog(@"userInfoRequest failed with error: %@", error);
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Can't Access User Info" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self updateViewForMode:RootViewModeIdle];		
	}
	
	else if ( request == self.userFriendsRequest )
	{
		self.userFriendsRequest = nil;
		
        NSLog(@"userFriendsRequest failed with error: %@", error);
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Can't Access Friend List" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
		
        [self updateViewForMode:RootViewModeIdle];		
	}
}


@end






