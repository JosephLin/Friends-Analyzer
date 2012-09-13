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


@interface RootViewController : UIViewController <FBSessionDelegate, FBRequestDelegate>

- (void)getUserInfo;

@end
