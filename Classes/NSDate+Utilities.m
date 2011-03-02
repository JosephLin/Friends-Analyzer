//
//  NSDate+Utilities.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "NSDate+Utilities.h"


@implementation NSDate (Utilities)

+ (NSDate*)dateFromFacebookFormat:(NSString*)dateString
{
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-ddTHH:mm:ssZ"];
	
	NSDate* date = [dateFormatter dateFromString:dateString];
	
	return date;
}

+ (NSDate*)startDateFromString:(NSString*)dateString
{
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM"];
	
	NSDate* date = [dateFormatter dateFromString:dateString];
	
	return date;
}

- (NSString*)stringFromDate
{
	NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MM/dd/yy hh:mm a"];
	
	NSString* dateString = [dateFormatter stringFromDate:self];
	
	return dateString;
}


@end
