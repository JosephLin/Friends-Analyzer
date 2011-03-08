//
//  FBUserOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Geocode.h"
#import "LocationName.h"


@protocol FBUserOperationDelegate;


@interface FBUserOperation : NSOperation
{
    id <FBUserOperationDelegate> delegate;
	NSString* graphPath;
}

@property (nonatomic, assign) id <FBUserOperationDelegate> delegate;
@property (nonatomic, retain) NSString* graphPath;

- (User*)userAtGraphPath:(NSString*)path;
- (Geocode*)geocodeForQuery:(NSString*)query;

@end
