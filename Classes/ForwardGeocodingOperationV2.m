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

@property (nonatomic, strong) CLGeocoder* geocoder;
@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@end



@implementation ForwardGeocodingOperationV2


- (id)initWithQuery:(NSString*)theQuery object:(id)theObject keyPath:(NSString*)theKeyPath
{
	if ( (self = [super init]) )
	{
		self.query = theQuery;
		self.object = theObject;
		self.keyPath = theKeyPath;

        self.geocoder = [[CLGeocoder alloc] init];

        self.isExecuting = NO;
		self.isFinished = NO;
	}
	return self;
}

- (void)dealloc
{
    [self.geocoder cancelGeocode];
}


#pragma mark -

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
	self.isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    if ( !self.query )
    {
        NSLog(@"Empty Query!");
        [self finish];
    }
    else if (![self isCancelled])
    {
        NSLog(@"Paring Location: %@", self.query);
        
        self.geocode = [Geocode geocodeForName:self.query];
        
        //// Geocode already exist. ////
        if ( self.geocode )
        {            
            NSLog(@"Geocode already exist: %@", self.geocode.formatted_address);

            if ( self.object && self.keyPath )
            {
                [self.object setValue:self.geocode forKeyPath:self.keyPath];
            }
            [self finish];
        }
        
        
        //// Geocode not exist. Send request to Google. ////
        else if (![self isCancelled])
        {
            [self.geocoder geocodeAddressString:self.query
                              completionHandler:^(NSArray* placemarks, NSError* error){
                                  
                                  if ( [placemarks count] )
                                  {
                                      CLPlacemark* aPlacemark = placemarks[0];
                                      
                                      self.geocode = [Geocode existingOrNewGeocodeWithpPlacemark:aPlacemark];
                                      [self.geocode addLocationNamesObject:[LocationName insertLocationNameWithName:self.query]];
                                      
                                      NSLog(@"Location parsed: %@", self.geocode.formatted_address);
                                      
                                      [self.object setValue:self.geocode forKeyPath:self.keyPath];
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
	
    self.isExecuting = NO;
    self.isFinished = YES;
	
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}




@end
