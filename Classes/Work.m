// 
//  Work.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Work.h"
#import "User.h"
#import "Geocode.h"
#import "NSDate+Utilities.h"

@implementation Work 

@dynamic employer;
@dynamic location;
@dynamic start_date;
@dynamic user;
@dynamic geocodeLocation;


+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict
{
	Work* work = [self insertNewObject];
	
	work.employer = [[dict objectForKey:@"employer"] objectForKey:@"name"];
	work.location = [[dict objectForKey:@"location"] objectForKey:@"name"];
	work.start_date = [NSDate dateFromYearMonth:[dict objectForKey:@"start_date"]];
	
	return work;
}


@end
