//
//  ForwardGeocodingOperationV2.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 8/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ForwardGeocodingOperationV2.h"
#import "LocationName.h"

@interface ForwardGeocodingOperationV2 ()
- (void)finish;
@end



@implementation ForwardGeocodingOperationV2
@synthesize query, geocode;
@synthesize object, keyPath;
@synthesize isExecuting, isFinished;


- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath
{
	if ( (self = [super init]) )
	{
		self.query = theQuery;
		self.object = theObject;
		self.keyPath = theKeyPath;

        geocoder = [[CLGeocoder alloc] init];

        isExecuting = NO;
		isFinished = NO;
	}
	return self;
}

- (void)dealloc
{
    [geocoder cancelGeocode];
    
	[query release];
    [geocode release];
    [object release];
    [keyPath release];
    [geocoder release];
	
	[super dealloc];
}


#pragma mark -

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
	isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    if ( !query )
    {
        NSLog(@"Empty Query!");
        [self finish];
    }
    else if (![self isCancelled])
    {
        NSLog(@"Paring Location: %@", query);
        
        self.geocode = [Geocode geocodeForName:query];
        
        //// Geocode already exist. ////
        if ( geocode )
        {            
            NSLog(@"Geocode already exist: %@", geocode.formatted_address);

            if ( object && keyPath )
            {
                [object setValue:geocode forKeyPath:keyPath];
            }
            [self finish];
        }
        
        
        //// Geocode not exist. Send request to Google. ////
        else if (![self isCancelled])
        {
            [geocoder geocodeAddressString:query
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             
                             if ( [placemarks count] )
                             {
                                 CLPlacemark* aPlacemark = [placemarks objectAtIndex:0];
                                 
                                 self.geocode = [Geocode existingOrNewGeocodeWithpPlacemark:aPlacemark];
                                 [geocode addLocationNamesObject:[LocationName insertLocationNameWithName:query]];
                                 
                                 NSLog(@"Location parsed: %@", geocode.formatted_address);
                                 
                                 [object setValue:geocode forKeyPath:keyPath];
                             }
                             [self finish];
                         }];
        }
        else
        {
            [self finish];
        }
    }
    else
    {
        [self finish];
    }
}

- (void)finish
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
	
    isExecuting = NO;
    isFinished = YES;
	
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}




@end
