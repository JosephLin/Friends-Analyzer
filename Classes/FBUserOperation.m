//
//  FBUserOperation.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBUserOperation.h"
#import "FacebookClient.h"


@implementation FBUserOperation

@synthesize delegate, graphPath;



- (id)initWithGraphPath:(NSString*)theGraphPath delegate:(id <FBUserOperationDelegate>)theDelegate
{
	if ( (self = [super init]) )
	{
		self.delegate = theDelegate;
		self.graphPath = theGraphPath;
	}
	return self;
}

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    if ( !graphPath )
    {
        NSLog(@"Empty graphPath!");
    }
    
    else if (![self isCancelled])
    {
        User* user = [self userAtGraphPath:self.graphPath];
        
    }
    
    
    
	[pool release];
}


- (User*)userAtGraphPath:(NSString*)path
{
    NSString* urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@&format=json"
                           , path, [[FacebookClient sharedFacebook] accessToken]];
    NSString* escapedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSString* responseString = [NSString stringWithContentsOfURL:[NSURL URLWithString:escapedString] encoding:NSUTF8StringEncoding error:&error];
    
    SBJSON *jsonParser = [[SBJSON new] autorelease];
    NSDictionary* responseDict = [jsonParser objectWithString:responseString];
    
    User* user = [User existingOrNewUserWithDictionary:responseDict];
    
    return user;
}

- (Geocode*)geocodeForQuery:(NSString*)query
{
    if ( !query )
    {
        NSLog(@"Empty Query!");
        return nil;
    }
    else if (![self isCancelled])
    {
        Geocode* geocode = [Geocode geocodeForName:query];
        
        //// Geocode already exist. ////
        if ( geocode )
        {
            NSLog(@"Geocode already exist: %@", geocode.formatted_address);
        }
        
        //// Geocode not exist. Send request to Google. ////
        else if (![self isCancelled])
        {
            NSString* urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", query];
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
                SBJSON *jsonParser = [[SBJSON new] autorelease];
                NSDictionary* responseDict = [jsonParser objectWithString:responseString];
                
                NSString* status = [responseDict objectForKey:@"status"];
                if ( [status isEqualToString:@"OK"] )
                {
                    NSArray* results = [responseDict objectForKey:@"results"];
                    
                    //// Just to be safe. Google should return "ZERO_RESULTS" if there's none. //
                    if ( [results count] )  
                    {
                        geocode = [Geocode existingOrNewGeocodeWithDictionary:[results objectAtIndex:0]];
                        [geocode addLocationNamesObject:[LocationName insertLocationNameWithName:query]];
                        
                        NSLog(@"Location parsed: %@", geocode.formatted_address);
                    }
                }
                else if  ( [status isEqualToString:@"ZERO_RESULTS"] )
                {
                    
                }
                else
                {
                    NSLog(@"urlString: %@", urlString);
                    NSLog(@"Failed with status: %@", status);
                }
            }
        }
        return geocode;
    }
    
    return nil;
}


- (void)dealloc
{
	[graphPath release];
	
	[super dealloc];
}


@end


