//
//  ForwardGeocodingOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Geocode.h"



@protocol ForwardGeocodingOperationDelegate;

@interface ForwardGeocodingOperation : NSOperation
{
   	id <ForwardGeocodingOperationDelegate> delegate;
	NSString* query;
    NSString* status;
	Geocode* geocode;

    id object;
    NSString* keyPath;
}

@property (nonatomic, assign) id <ForwardGeocodingOperationDelegate> delegate;
@property (nonatomic, retain) NSString* query;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) Geocode* geocode;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) NSString* keyPath;

- (id)initWithQuery:(NSString*)theQuery delegate:(id <ForwardGeocodingOperationDelegate>)theDelegate;

@end


@protocol ForwardGeocodingOperationDelegate <NSObject>
@optional
- (void)operationDidFinish:(ForwardGeocodingOperation*)op;
- (void)operation:(ForwardGeocodingOperation*)op didFailWithError:(NSError*)error;
@end
