//
//  MainMenuViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "NSDate+Utilities.h"
#import "ArrayBasedTableViewController.h"
#import "LocationViewController.h"
#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FacebookSDK.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

#define kLogoutActionSheetTag       1001
#define kRefreshActionSheetTag      2001



@interface MainMenuViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* friendsCountLabel;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) IBOutlet UILabel* lastUpdatedLabel;

@property (nonatomic, strong) NSArray* menuStructureArray;
@property (nonatomic, strong) User* currentUser;

@end



@implementation MainMenuViewController


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
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:self.currentUser.name attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
    
    [attrString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%d Friends", [self.currentUser.friends count]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}]];
    
	self.nameLabel.attributedText = attrString;
    
    NSString* avatar = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.currentUser.id];
    [self.profileImageView setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:nil];

//    [self.profileImageView setImageWithURL:[NSURL URLWithString:avatar]
//                          placeholderImage:nil
//                                   success:^(UIImage *image, BOOL cached) {
//                                       
//                                       CGFloat width = self.profileImageView.bounds.size.width;
//                                       CGFloat ratio = width / image.size.width;
//                                       CGFloat height = image.size.height * ratio;
//                                       self.profileImageView.bounds = CGRectMake(0, 0, width, height);
//                                       
//                                       CALayer* layer = self.profileImageView.layer;
//                                       layer.masksToBounds = YES;
//                                       layer.cornerRadius = 10.0;
//                                       layer.borderWidth = 1.0;
//                                       layer.borderColor = [UIColor darkGrayColor].CGColor;
//                                       
//                                   } failure:^(NSError *error) {
//                                       
//                                       NSLog(@"Failed to load image: %@", error);
//                                   }];
	
	//// Load Property List ////
	NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"MenuStructure" ofType:@"plist"];
	self.menuStructureArray = [NSArray arrayWithContentsOfFile:plistPath];
	
	[self.tableView reloadData];
	
	
	NSDate* lastUpdated = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdated"];
	self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Updated: %@", [lastUpdated stringFromDate]];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - IBAction

- (IBAction)refreshButtonTapped:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Depending on your connection, refresh might take up to serveral minutes." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Refresh" otherButtonTitles:nil];
    sheet.tag = kRefreshActionSheetTag;
    [sheet showInView:self.view];
}

- (void)logoutButtonTapped:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"To protect your privacy, all stored friend information will be deleted when you logout." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:nil];
    sheet.tag = kLogoutActionSheetTag;
    [sheet showInView:self.view];
}

- (void)debugButtonTapped:(id)sender
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


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuStructureArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * cellIdentifier = @"BasicCell";
	
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	NSDictionary* menuDictionary = self.menuStructureArray[indexPath.row];
    cell.textLabel.text = menuDictionary[@"title"];
    
    UIImage* iconImage = [UIImage imageNamed:menuDictionary[@"property"]];
    cell.imageView.image = iconImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSDictionary* menuDictionary = self.menuStructureArray[indexPath.row];
	NSString* viewControllerName = menuDictionary[@"viewController"];
	Class aClass = [[NSBundle mainBundle] classNamed:viewControllerName];

	UIViewController* childVC = [[aClass alloc] init];
    childVC.title = menuDictionary[@"title"];
	if ( [childVC isKindOfClass:[ArrayBasedTableViewController class]] )
	{
		((ArrayBasedTableViewController*)childVC).property = self.menuStructureArray[indexPath.row][@"property"];
	}
    [self.navigationController pushViewController:childVC animated:YES];
}


#pragma mark - Facebook

- (void)facebookLogout
{
    [FBSession.activeSession closeAndClearTokenInformation];
	[(AppDelegate*)[[UIApplication sharedApplication] delegate] deleteCoreDataStorage];
	[self.navigationController popViewControllerAnimated:YES];
}



@end



