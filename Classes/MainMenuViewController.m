//
//  MainMenuViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "MainMenuViewController.h"
#import "FriendsAnalyzerAppDelegate.h"
#import "NSDate+Utilities.h"
#import "ArrayBasedTableViewController.h"
#import "LocationViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation MainMenuViewController

@synthesize headerView, profileImageView, nameLabel, friendsCountLabel, tableView, lastUpdatedLabel;
@synthesize menuStructureArray;
@synthesize currentUser;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//// Set Navigation Bar ////
	self.title = @"Home";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" 
																			   style:UIBarButtonItemStylePlain 
																			  target:self 
																			  action:@selector(facebookLogout)] autorelease];

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
    [queue release];

    [headerView release];
    [profileImageView release];
	[nameLabel release];
	[friendsCountLabel release];
	[tableView release];
	[lastUpdatedLabel release];
	[menuStructureArray release];
	[currentUser release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (IBAction)refreshButtonTapped:(id)sender
{
    RootViewController* rootVC = [self.navigationController.viewControllers objectAtIndex:0];
    [rootVC getUserInfo];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark -
#pragma mark Profile Image

- (void)loadProfileImage
{
    if ( queue )
    {
        [queue cancelAllOperations];
        [queue release];
    }
    queue = [[NSOperationQueue alloc] init];
    
    self.currentUser = [User currentUser];
	NSString* avatarURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", currentUser.id];
	
    AsyncImageOperation* op = [[AsyncImageOperation alloc] initWithURL:avatarURL delegate:self];
    [queue addOperation:op];
    [op release];
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSDictionary* dict = [menuStructureArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
	NSDictionary* menuDictionary = [menuStructureArray objectAtIndex:indexPath.row];
	NSString* viewControllerName = [menuDictionary objectForKey:@"viewController"];
	
	Class aClass = [[NSBundle mainBundle] classNamed:viewControllerName];
	UIViewController* childVC = [[[aClass alloc] init] autorelease];
	if ( [childVC isKindOfClass:[ArrayBasedTableViewController class]] )
	{
		((ArrayBasedTableViewController*)childVC).property = [[menuStructureArray objectAtIndex:indexPath.row] objectForKey:@"property"];
	}
    [self.navigationController pushViewController:childVC animated:YES];
}


#pragma mark -
#pragma mark Facebook

- (void)facebookLogout
{
	[[FacebookClient sharedFacebook] logout:self];
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogout
{
	NSLog(@"did logout");

	[(FriendsAnalyzerAppDelegate*)[[UIApplication sharedApplication] delegate] deleteCoreDataStorage];
	
	[self.navigationController popViewControllerAnimated:YES];
}





@end



