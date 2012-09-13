//
//  FBRequestOperation.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "FBRequestOperation.h"
#import "FacebookSDK.h"
#import "User.h"

@interface FBRequestOperation ()
- (void)finish;
@end


@implementation FBRequestOperation

@synthesize delegate;
@synthesize graphPath, request;
@synthesize isExecuting, isFinished;


- (id)initWithGraphPath:(NSString*)thePath delegate:(id <FBRequestOperationDelegate>)theDelegate
{
	if ( (self = [super init]) )
	{
		self.delegate = theDelegate;
		self.graphPath = thePath;
		
		isExecuting = NO;
		isFinished = NO;
	}
	return self;
}


- (BOOL)isConcurrent
{
    return YES;
}


- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
	isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
	
//	self.request = [[FacebookClient sharedFacebook] requestWithGraphPath:graphPath andDelegate:self];

    if (request == nil)
        [self finish];
}

- (void)finish
{
    request = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
	
    isExecuting = NO;
    isFinished = YES;
	
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didLoad:(id)result
{
	[User existingOrNewUserWithDictionary:result];
    
	if ( [delegate respondsToSelector:@selector(requestOpertaion:didLoad:)] )
	{
		[delegate requestOpertaion:self didLoad:result];
	}

	[self finish];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog(@"FBRequest failed with error: %@", error);
    
	if ( [delegate respondsToSelector:@selector(requestOpertaion:didFailWithError:)] )
	{
		[delegate requestOpertaion:self didFailWithError:error];
	}
    
	[self finish];    
}





@end
