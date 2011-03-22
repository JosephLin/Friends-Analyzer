//
//  AsyncImageOperation.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageOperation.h"


@implementation AsyncImageOperation

@synthesize delegate;
@synthesize URL;
@synthesize data;



- (id)initWithURL:(NSString*)theURL delegate:(id <AsyncImageOperationDelegate>)theDelegate
{
	if ( (self = [super init]) )
	{
		self.delegate = theDelegate;
		self.URL = theURL;
	}
	return self;
}

- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    if ( !URL )
    {
        NSLog(@"Empty Query!");
    }
    else if (![self isCancelled])
    {
        NSString* escapedString = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedString]];

        NSError* error = nil;
        NSURLResponse* response = nil;
        self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];            
        
        //// Connection failed ////
        if ( error )
        {
            NSLog(@"error = %@", error);
            
            if ( [delegate respondsToSelector:@selector(operation:didFailWithError:)] )
                [delegate operation:self didFailWithError:error];
        }
        
        //// Connection succeeded ////
        else if (![self isCancelled])
        {
            if ( [delegate respondsToSelector:@selector(operation:didLoadData:)] )
                [delegate operation:self didLoadData:self.data];
        }
    }
    
	[pool release];
}



- (void)dealloc
{
	[URL release];
    [data release];
	
	[super dealloc];
}


@end
