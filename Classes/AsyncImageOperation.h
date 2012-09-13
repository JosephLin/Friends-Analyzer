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
  	id <AsyncImageOperationDelegate> __weak delegate;
	NSString* URL;
    NSData* data;
}

@property (nonatomic, weak) id <AsyncImageOperationDelegate> delegate;
@property (nonatomic, strong) NSString* URL;
@property (nonatomic, strong) NSData* data;

- (id)initWithURL:(NSString*)theURL delegate:(id <AsyncImageOperationDelegate>)theDelegate;

@end


@protocol AsyncImageOperationDelegate <NSObject>
@optional
- (void)operation:(AsyncImageOperation*)op didLoadData:(NSData*)data;
- (void)operation:(AsyncImageOperation*)op didFailWithError:(NSError*)error;
@end