//
//  ForwardGeocodingOperation.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ForwardGeocodingOperation.h"
#import "SBJSON.h"
#import "LocationName.h"

#define kTimeoutInterval	10.0

// Status Codes:
//"OK" indicates that no errors occurred; the address was successfully parsed and at least one geocode was returned.
//"ZERO_RESULTS" indicates that the geocode was successful but returned no results. This may occur if the geocode was passed a non-existent address or a latlng in a remote location.
//"OVER_QUERY_LIMIT" indicates that you are over your quota.
//"REQUEST_DENIED" indicates that your request was denied, generally because of lack of a sensor parameter.
//"INVALID_REQUEST" generally indicates that the query (address or latlng) is missing.


@implementation ForwardGeocodingOperation

@synthesize query, status, geocode;
@synthesize object, keyPath;


- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath
{
	if ( (self = [super init]) )
	{
		self.query = theQuery;
		self.object = theObject;
		self.keyPath = theKeyPath;
	}
	return self;
}

- (void)main
{
	@autoreleasepool {
	
        if ( !query )
        {
            NSLog(@"Empty Query!");
        }
        else if (![self isCancelled])
        {
            self.geocode = [Geocode geocodeForName:query];
            
            //// Geocode already exist. ////
            if ( geocode )
            {
//            NSLog(@"Geocode already exist: %@", geocode.formatted_address);
            }
            
            
            //// Geocode not exist. Send request to Google. ////
            else if (![self isCancelled])
            {
                NSString* urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", self.query];
                NSString* escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSError* error = nil;
                NSString* responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedString] encoding:NSUTF8StringEncoding error:&error];
                
                
                //// Connection failed ////
                if ( error )
                {
                    NSLog(@"urlString = %@", urlString);
                    NSLog(@"error = %@", error);
                }

                //// Connection succeeded ////
                else if (![self isCancelled])
                {
                    SBJSON *jsonParser = [SBJSON new];
                    NSDictionary* responseDict = [jsonParser objectWithString:responseString];
                    
                    self.status = responseDict[@"status"];
                    if ( [status isEqualToString:@"OK"] )
                    {
                        NSArray* results = responseDict[@"results"];
                        
                        //// Just to be safe. Google should return "ZERO_RESULTS" if there's none. //
                        if ( [results count] )  
                        {
                            self.geocode = [Geocode existingOrNewGeocodeWithDictionary:results[0]];
                            [geocode addLocationNamesObject:[LocationName insertLocationNameWithName:query]];
                            
                            NSLog(@"Location parsed: %@", geocode.formatted_address);
                        }
                    }
                    else if  ( [status isEqualToString:@"ZERO_RESULTS"] )
                    {
                        self.geocode = [Geocode unknownGeocode];
                        [geocode addLocationNamesObject:[LocationName insertLocationNameWithName:query]];
                        NSLog(@"ZERO RESULTS: %@", geocode.formatted_address);
                    }
                    else
                    {
                        NSLog(@"urlString: %@", urlString);
                        NSLog(@"Failed with status: %@", status);
                    }
                }
            }
            
            if ( object && keyPath )
            {
                [object setValue:geocode forKeyPath:keyPath];
            }
        }

	}
}





@end
