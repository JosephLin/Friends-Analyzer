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
@dynamic position;
@dynamic location;
@dynamic start_date;
@dynamic end_date;
@dynamic user;
@dynamic geocodeLocation;


+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict
{
	Work* work = [self insertNewObject];
	
    work.employer = [ObjectAttribute entity:@"Employer" withName:[[dict objectForKey:@"employer"] objectForKey:@"name"]];
    work.position = [ObjectAttribute entity:@"Position" withName:[[dict objectForKey:@"position"] objectForKey:@"name"]];

	work.location = [[dict objectForKey:@"location"] objectForKey:@"name"];
	work.start_date = [NSDate dateFromYearMonth:[dict objectForKey:@"start_date"]];
	work.end_date = [NSDate dateFromYearMonth:[dict objectForKey:@"end_date"]];
	
	return work;
}

+ (NSArray*)allWorks
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

- (NSString*)workDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM"];
	
    if ( self.start_date)
    {
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
