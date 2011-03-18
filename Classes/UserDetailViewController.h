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
}

@property (nonatomic, retain) User* user;   
@property (nonatomic, retain) NSMutableArray* keyPaths;
@property (nonatomic, retain) NSArray* works;
@property (nonatomic, retain) NSArray* educations;
@property (nonatomic, retain) NSDictionary* displayNameDict;

- (NSString*)descriptionForWork:(Work*)work;
- (NSString*)descriptionForEducation:(Education*)education;


@end
