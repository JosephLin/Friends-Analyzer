//
//  NSDate+Utilities.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "NSDate+Utilities.h"


@implementation NSDate (Utilities)

+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)dateFormat
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:dateFormat];
	
	NSDate* date = [dateFormatter dateFromString:dateString];
    
	return date;
}

+ (NSDate*)dateFromFacebookFullFormat:(NSString*)dateString
{
	NSDate* date = [self dateFromString:dateString format:@"yyyy-MM-dd'T'HH:mm:ssZ"];
	return date;
}

+ (NSDate*)dateFromFacebookBirthday:(NSString*)dateString
{
    NSDate* date = [self dateFromString:dateString format:@"MM/dd/yyyy"];
	return date;
}

+ (NSDate*)dateFromYearMonth:(NSString*)dateString
{
    NSDate* date = [self dateFromString:dateString format:@"yyyy-MM"];
	return date;
}

- (NSString*)stringFromDate
{
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yy hh:mm a"];
	
	NSString* dateString = [dateFormatter stringFromDate:self];
	
	return dateString;
}



@end
