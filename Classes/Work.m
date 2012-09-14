// 
//  Work.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "Work.h"
#import "User.h"
#import "Geocode.h"
#import "NSDate+Utilities.h"

@implementation Work 

@dynamic employer;
@dynamic position;
@dynamic location;
@dynamic start_date;
@dynamic end_date;
@dynamic user;
@dynamic geocodeLocation;


+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict
{
	Work* work = [self insertNewObject];
	
    work.employer = [ObjectAttribute entity:@"Employer" withName:dict[@"employer"][@"name"]];
    work.position = [ObjectAttribute entity:@"Position" withName:dict[@"position"][@"name"]];

	work.location = dict[@"location"][@"name"];
	work.start_date = [NSDate dateFromYearMonth:dict[@"start_date"]];
	work.end_date = [NSDate dateFromYearMonth:dict[@"end_date"]];
	
	return work;
}

+ (NSArray*)allWorks
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

- (NSString*)workDate
{
	
    if ( self.start_date)
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM"];

        NSString* startDateString = [dateFormatter stringFromDate:self.start_date];
        NSString* endDateString = ( self.end_date ) ? [dateFormatter stringFromDate:self.end_date] : @"Present";
        NSString* dateString = [NSString stringWithFormat:@"%@ to %@", startDateString, endDateString];
        
        
        return dateString;
    }
    else
    {
        return nil;
    }
}


@end
