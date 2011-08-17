//
//  ForwardGeocodingOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Geocode.h"


@interface ForwardGeocodingOperation : NSOperation
{
	NSString* query;
    NSString* status;
	Geocode* geocode;

    id object;
    NSString* keyPath;
}

@property (nonatomic, retain) NSString* query;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) Geocode* geocode;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString* keyPath;

- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath;

@end


