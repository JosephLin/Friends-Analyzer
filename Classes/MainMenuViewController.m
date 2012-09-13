//
//  MainMenuViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "NSDate+Utilities.h"
#import "ArrayBasedTableViewController.h"
#import "LocationViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>

#define kLogoutActionSheetTag       1001
#define kRefreshActionSheetTag      2001


@implementation MainMenuViewController

@synthesize headerView, profileImageView, nameLabel, friendsCountLabel, tableView, lastUpdatedLabel;
@synthesize menuStructureArray;
@synthesize currentUser;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
	
	//// Set Navigation Bar ////
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	self.title = @"Home";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" 
																			   style:UIBarButtonItemStylePlain 
																			  target:self 
																			  action:@selector(logoutButtonTapped:)];

	//// Display Current User Info ////
	self.currentUser = [User currentUser];
	self.nameLabel.text = currentUser.name;
	self.friendsCountLabel.text = [NSString stringWithFormat:@"%d Friends", [currentUser.friends count]];
    
    [self loadProfileImage];
	
	
	//// Load Property List ////
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"MenuStructure" ofType:@"plist"];
	self.menuStructureArray = [NSArray arrayWithContentsOfFile:plistPath];
	
	[tableView reloadData];
	
	
	NSDate* lastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdated"];
	self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Updated: %@", [lastUpdated stringFromDate]];    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.headerView = nil;
	self.profileImageView = nil;
	self.nameLabel = nil;
	self.friendsCountLabel = nil;
	self.tableView = nil;
	self.lastUpdatedLabel = nil;
}

- (void)dealloc
{
	[queue cancelAllOperations];


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (IBAction)refreshButtonTapped:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Depending on your connection, refresh might take up to serveral minutes." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Refresh" otherButtonTitles:nil];
    sheet.tag = kRefreshActionSheetTag;
    [sheet showInView:self.view];
}

- (IBAction)logoutButtonTapped:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"To protect your privacy, all stored friend information will be deleted when you logout." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    sheet.tag = kLogoutActionSheetTag;
    [sheet showInView:self.view];
}

- (IBAction)debugButtonTapped:(id)sender
{
    for ( id object in [Geocode allGeocodes] )
    {
        [[Geocode managedObjectContext] deleteObject:object];
    }
    [[Geocode managedObjectContext] save:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == [actionSheet destructiveButtonIndex] )
    {
        if ( actionSheet.tag == kLogoutActionSheetTag )
        {
            [self facebookLogout];
        }
        else
        {
            [[User managedObjectContext] deleteObject:[User currentUser]];
            
            RootViewController* rootVC = (self.navigationController.viewControllers)[0];
            [rootVC getUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark -
#pragma mark Profile Image

- (void)loadProfileImage
{
    if ( queue )
    {
        [queue cancelAllOperations];
    }
    queue = [[NSOperationQueue alloc] init];
    
    self.currentUser = [User currentUser];
	NSString* avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", currentUser.id];
	
    AsyncImageOperation* op = [[AsyncImageOperation alloc] initWithURL:avatarURL delegate:self];
    [queue addOperation:op];
}

- (void)operation:(AsyncImageOperation*)op didLoadData:(NSData*)data
{
    [self performSelectorOnMainThread:@selector(setImageViewWithData:) withObject:data waitUntilDone:NO];
}

- (void)setImageViewWithData:(NSData*)data
{
    UIImage* image = [UIImage imageWithData:data];
    headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, image.size.height + 20.0 );
    self.tableView.tableHeaderView = headerView;
    profileImageView.image = image;
    
    CALayer* layer = [profileImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
}


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuStructureArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"Cell";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSDictionary* menuDictionary = menuStructureArray[indexPath.row];
    cell.textLabel.text = menuDictionary[@"title"];
    
    UIImage* iconImage = [UIImage imageNamed:menuDictionary[@"property"]];
    cell.imageView.image = iconImage;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary* menuDictionary = menuStructureArray[indexPath.row];
	NSString* viewControllerName = menuDictionary[@"viewController"];
	Class aClass = [[NSBundle mainBundle] classNamed:viewControllerName];

	UIViewController* childVC = [[aClass alloc] init];
    childVC.title = menuDictionary[@"title"];
	if ( [childVC isKindOfClass:[ArrayBasedTableViewController class]] )
	{
		((ArrayBasedTableViewController*)childVC).property = menuStructureArray[indexPath.row][@"property"];
	}
    [self.navigationController pushViewController:childVC animated:YES];
}


#pragma mark -
#pragma mark Facebook

- (void)facebookLogout
{
//	[[FacebookClient sharedFacebook] logout:self];
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogout
{
	NSLog(@"did logout");

	[(AppDelegate*)[[UIApplication sharedApplication] delegate] deleteCoreDataStorage];
	
	[self.navigationController popViewControllerAnimated:YES];
}





@end



