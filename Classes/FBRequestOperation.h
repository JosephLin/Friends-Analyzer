//
//  FBRequestOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"



@interface FBRequestOperation : NSOperation

@property (nonatomic, strong) NSString* graphPath;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

- (id)initWithGraphPath:(NSString*)thePath;

@end

