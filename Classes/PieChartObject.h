//
//  PieChartObject.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PieChartObject : NSObject
{
    NSString* key;
    NSString* value;
    NSString* displayName;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* value;
@property (nonatomic, retain) NSString* displayName;

- (id)initWithKey:(NSString*)theKey value:(NSString*)theValue displayName:(NSString*)theName;

@end
