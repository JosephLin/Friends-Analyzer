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

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@end



@implementation FBRequestOperation


- (id)initWithGraphPath:(NSString*)thePath
{
	if ( (self = [super init]) )
	{
		self.graphPath = thePath;
		
		self.isExecuting = NO;
		self.isFinished = NO;
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
	self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
	
    [FBRequestConnection startWithGraphPath:self.graphPath completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error)
        {
            [User existingOrNewUserWithDictionary:result];            
            [self finish];
        }
        else
        {
            NSLog(@"FBRequest failed with error: %@", error);
            [self finish];
        }
    }];
}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
	
    self.isExecuting = NO;
    self.isFinished = YES;
	
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}







@end
