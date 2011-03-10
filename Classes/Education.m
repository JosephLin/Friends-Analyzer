// 
//  Education.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Education.h"

#import "Concentration.h"
#import "User.h"

@implementation Education 

@dynamic school;
@dynamic degree;
@dynamic year;
@dynamic concentrations;
@dynamic type;
@dynamic user;


+ (Education*)insertEducationWithDictionary:(NSDictionary*)dict
{
	Education* education = [self insertNewObject];
	
	education.school = [[dict objectForKey:@"school"] objectForKey:@"name"];
	education.degree = [[dict objectForKey:@"degree"] objectForKey:@"name"];
	education.year = [[dict objectForKey:@"year"] objectForKey:@"name"];
	education.type = [dict objectForKey:@"type"];
	
	NSArray* concentrationArray = [dict objectForKey:@"concentration"];
	for ( id dict in concentrationArray )
	{
		[education addConcentrationsObject:[Concentration insertConcentrationWithDictionary:dict]];
	}
	
	return education;
}



#pragma mark - 
#pragma mark For Table View

+ (NSArray*)educationsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (NSUInteger)educationCountsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
	
	return count;
}

+ (NSArray*)possibleValuesForCategory:(NSString*)category
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	[request setResultType:NSDictionaryResultType];
	[request setReturnsDistinctResults:YES];
	[request setPropertiesToFetch:[NSArray arrayWithObject:category]];
	
	// Execute the fetch
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
	return results;
}



@end
