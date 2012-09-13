//
//  FBRequestOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"



@interface FBRequestOperation : NSOperation

@property (nonatomic, strong) NSString* graphPath;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

- (id)initWithGraphPath:(NSString*)thePath;

@end

