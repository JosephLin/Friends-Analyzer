//
//  PieChartObject.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/29/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "PieChartObject.h"


@implementation PieChartObject



- (id)initWithKey:(NSString*)theKey value:(NSString*)theValue displayName:(NSString*)theName
{
    self = [super init];
    if (self)
    {
        self.key = theKey;
        self.value = theValue;
        self.displayName = theName;
    }
    return self;
}


@end
