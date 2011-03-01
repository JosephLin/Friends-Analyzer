//
//  FacebookClient.m
//  NikeBoom
//
//  Created by Joseph Lin on 12/18/10.
//  Copyright 2010 R/GA. All rights reserved.
//

#import "FacebookClient.h"

#define kFacebookAppID	@"202399393103982"

static Facebook* sharedFacebook;

@implementation FacebookClient


+ (Facebook*)sharedFacebook
{
	if ( !sharedFacebook )
	{
		sharedFacebook = [[Facebook alloc] initWithAppId:kFacebookAppID];
		sharedFacebook.accessToken  = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
		sharedFacebook.expirationDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
	}
	
	return sharedFacebook;
}

@end