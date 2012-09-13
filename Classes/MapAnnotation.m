//
//  MapAnnotation.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate;
@synthesize formattedAddress;
@synthesize owners;




- (NSString*)title
{
    return formattedAddress;
}

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"%d", [owners count]];
}

@end
