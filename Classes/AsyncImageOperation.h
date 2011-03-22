//
//  AsyncImageOperation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AsyncImageOperationDelegate;

@interface AsyncImageOperation : NSOperation
{
  	id <AsyncImageOperationDelegate> delegate;
	NSString* URL;
    NSData* data;
}

@property (nonatomic, assign) id <AsyncImageOperationDelegate> delegate;
@property (nonatomic, retain) NSString* URL;
@property (nonatomic, retain) NSData* data;

- (id)initWithURL:(NSString*)theURL delegate:(id <AsyncImageOperationDelegate>)theDelegate;

@end


@protocol AsyncImageOperationDelegate <NSObject>
@optional
- (void)operation:(AsyncImageOperation*)op didLoadData:(NSData*)data;
- (void)operation:(AsyncImageOperation*)op didFailWithError:(NSError*)error;
@end