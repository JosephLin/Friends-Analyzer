//
//  UserDetailViewController.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Work.h"
#import "Education.h"


@interface UserDetailViewController : UITableViewController
{
    User* user;
    
    NSMutableArray* keyPaths;
    NSArray* works;
    NSArray* educations;
    NSDictionary* displayNameDict;
    
    UIView* headerView;
    UIImageView* profileImageView;
    UILabel* nameLabel;
    
    NSOperationQueue* queue;
}

@property (nonatomic, strong) User* user;   
@property (nonatomic, strong) NSMutableArray* keyPaths;
@property (nonatomic, strong) NSArray* works;
@property (nonatomic, strong) NSArray* educations;
@property (nonatomic, strong) NSDictionary* displayNameDict;
@property (nonatomic, strong) IBOutlet UIView* headerView;
@property (nonatomic, strong) IBOutlet UIImageView* profileImageView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;

- (void)loadProfileImage;
- (void)setImageViewWithData:(NSData*)data;
- (NSString*)descriptionForWork:(Work*)work;
- (NSString*)descriptionForEducation:(Education*)education;
- (IBAction)openProfilePageLink;

@end
