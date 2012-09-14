//
//  ForwardGeocodingOperationV2.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 8/17/11.
//  Copyright (c) 2011 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Geocode.h"


@interface ForwardGeocodingOperationV2 : NSOperation

@property (nonatomic, strong) NSString* query;
@property (nonatomic, strong) Geocode* geocode;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString* keyPath;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath;

@end
