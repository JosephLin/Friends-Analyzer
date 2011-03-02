//
//  FBRequestOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookClient.h"


@protocol FBRequestOperationDelegate;

@interface FBRequestOperation : NSOperation <FBRequestDelegate>
{
	id <FBRequestOperationDelegate> delegate;
	NSString* graphPath;
	FBRequest* request;
	
    BOOL isExecuting;
    BOOL isFinished;
}

@property (nonatomic, assign) id <FBRequestOperationDelegate> delegate;
@property (nonatomic, retain) NSString* graphPath;
@property (nonatomic, retain) FBRequest* request;
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id)initWithGraphPath:(NSString*)thePath delegate:(id <FBRequestOperationDelegate>)theDelegate;

@end



@protocol FBRequestOperationDelegate <NSObject>
@optional
- (void)requestOpertaion:(FBRequestOperation *)op didLoad:(id)result;
- (void)requestOpertaion:(FBRequestOperation *)op didFailWithError:(NSError *)error;
@end