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
#import "AsyncImageOperation.h"


@interface UserDetailViewController : UITableViewController <AsyncImageOperationDelegate>
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

@property (nonatomic, retain) User* user;   
@property (nonatomic, retain) NSMutableArray* keyPaths;
@property (nonatomic, retain) NSArray* works;
@property (nonatomic, retain) NSArray* educations;
@property (nonatomic, retain) NSDictionary* displayNameDict;
@property (nonatomic, retain) IBOutlet UIView* headerView;
@property (nonatomic, retain) IBOutlet UIImageView* profileImageView;
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;

- (void)loadProfileImage;
- (void)setImageViewWithData:(NSData*)data;
- (NSString*)descriptionForWork:(Work*)work;
- (NSString*)descriptionForEducation:(Education*)education;
- (IBAction)openProfilePageLink;

@end