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
@synthesize title;
@synthesize users;



- (void)dealloc
{
    [title release];
    [users release];
    [super dealloc];
}

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"%d", [users count]];
}

@end
