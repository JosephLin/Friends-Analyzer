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

@property (nonatomic, strong) NSString* query;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) Geocode* geocode;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString* keyPath;

- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath;

@end


