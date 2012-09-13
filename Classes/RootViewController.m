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
#import "FacebookSDK.h"

typedef enum {
	RootViewModeIdle = 0,
	RootViewModeLoadingUserInfo,
	RootViewModeLoadingUserFriends,
	RootViewModeLoadingFriendsInfo
} RootViewMode;



@interface RootViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel *introLabel;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;
@property (nonatomic, strong) IBOutlet UILabel* loadingLabel;
@property (nonatomic, strong) IBOutlet UIProgressView* progressView;

@property (nonatomic, strong) User* currentUser;
@property (nonatomic, strong) FBRequest* userInfoRequest;
@property (nonatomic, strong) FBRequest* userFriendsRequest;
@property (nonatomic, strong) NSOperationQueue* queue;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger pending;

@end



@implementation RootViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    UIImage* image = [[UIImage imageNamed:@"icon-tile"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.backgroundImageView.image = image;
    
    self.introLabel.font = [UIFont fontWithName:@"CorporateRoundedBoldSWFTE" size:self.introLabel.font.pointSize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.currentUser = [User currentUser];
    
	if ( self.currentUser )
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

- (void)updateViewForMode:(RootViewMode)mode
{
	switch (mode)
	{
		case RootViewModeLoadingUserInfo:
			self.loginButton.hidden = YES;
			self.loadingLabel.hidden = NO;
			self.loadingLabel.text = @"Loading User Info...";
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			self.progressView.hidden = YES;
			break;
			
		case RootViewModeLoadingUserFriends:
			self.loginButton.hidden = YES;
			self.loadingLabel.hidden = NO;
			self.loadingLabel.text = @"Loading Friends...";
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			self.progressView.hidden = NO;			
			self.progressView.progress = 0;
			break;
			
		case RootViewModeLoadingFriendsInfo:
			self.loginButton.hidden = YES;
			self.loadingLabel.hidden = NO;
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
			self.progressView.hidden = NO;			
			break;
			
        case RootViewModeIdle:
        default:
			self.loginButton.hidden = NO;
			self.loadingLabel.hidden = YES;
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			self.progressView.hidden = YES;
			break;
	}
}

- (void)updateViewForProgress
{
	self.loadingLabel.text = [NSString stringWithFormat:@"Loading %d of %d Friends...", self.total - self.pending, self.total];
	self.progressView.progress = (float)(self.total - self.pending) / self.total;
}


#pragma mark - IBAction

- (IBAction)loginButtonTapped:(id)sender
{
	[self openSessionWithAllowLoginUI:YES];
}

- (void)showMainMenuViewController
{
    [self performSegueWithIdentifier:@"MainMenuSegue" sender:self];
}


#pragma mark - Facebook

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray* permissions = @[@"user_about_me", @"friends_about_me",
    @"user_birthday", @"friends_birthday",
    @"user_education_history", @"friends_education_history",
    @"user_hometown", @"friends_hometown",
    @"user_location", @"friends_location",
    @"user_relationships", @"friends_relationships",
    @"user_work_history", @"friends_work_history",
    @"user_education_history", @"friends_education_history"];
	
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        
        switch (state)
        {
            case FBSessionStateOpen:
                if (!error) {
                    [self getUserInfo];
                }
                break;
            case FBSessionStateClosed:
            case FBSessionStateClosedLoginFailed:
                [FBSession.activeSession closeAndClearTokenInformation];
                break;
            default:
                break;
        }
        
        
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)getUserInfo
{
	[self updateViewForMode:RootViewModeLoadingUserInfo];

    if ( [[FBSession activeSession] isOpen] )
    {
        [FBRequestConnection startWithGraphPath:@"me" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            if (!error)
            {
                self.currentUser = [User existingOrNewUserWithDictionary:result];
                NSLog(@"Current User: %@", self.currentUser);
                
                [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.id forKey:@"CurrentUserID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self fetchFriends];
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"Can't Access User Info"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
                [self updateViewForMode:RootViewModeIdle];
            }
        }];
    }
    else
    {
        [self openSessionWithAllowLoginUI:NO];
    }
}

- (void)fetchFriends
{
	[self updateViewForMode:RootViewModeLoadingUserFriends];
	
    [FBRequestConnection startWithGraphPath:@"me/friends" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            self.currentUser.friends = result[@"data"];
            [self parseFriends];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Can't Access Friend List"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            [self updateViewForMode:RootViewModeIdle];
        }
    }];
}

- (void)parseFriends
{
	self.total = [self.currentUser.friends count];
	
	if ( self.queue )
	{
		[self.queue cancelAllOperations];
	}
	self.queue = [[NSOperationQueue alloc] init];
    [self.queue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:NULL];	

	NSMutableArray* opArray = [NSMutableArray arrayWithCapacity:self.total];
	for ( id friend in self.currentUser.friends )
	{
		NSString* friendID = friend[@"id"];
		FBRequestOperation* op = [[FBRequestOperation alloc] initWithGraphPath:friendID];
		[opArray addObject:op];
	}
	[self.queue setMaxConcurrentOperationCount:5];
	[self.queue addOperations:opArray waitUntilFinished:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( [keyPath isEqualToString:@"operationCount"] )
	{
		self.pending = [self.queue operationCount];
		
		[self performSelectorOnMainThread:@selector(updateViewForProgress) withObject:nil waitUntilDone:NO];
		
		if ( self.pending == 0 )
		{
            [[User managedObjectContext] save:nil];
            
            [self.queue removeObserver:self forKeyPath:@"operationCount"];
			[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastUpdated"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelectorOnMainThread:@selector(showMainMenuViewController) withObject:nil waitUntilDone:NO];
		}
	}
}



@end






