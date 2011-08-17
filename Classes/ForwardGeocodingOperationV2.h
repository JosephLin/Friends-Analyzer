//
//  ForwardGeocodingOperationV2.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Geocode.h"


@interface ForwardGeocodingOperationV2 : NSOperation
{
	NSString* query;
	Geocode* geocode;
    
    id object;
    NSString* keyPath;
    
    CLGeocoder* geocoder;
        
    BOOL isExecuting;
    BOOL isFinished;
}

@property (nonatomic, retain) NSString* query;
@property (nonatomic, retain) Geocode* geocode;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString* keyPath;
@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath;


@end
