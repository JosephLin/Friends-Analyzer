// 
//  Concentration.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Concentration.h"


@implementation Concentration 

@dynamic name;
@dynamic education;

+ (Concentration*)insertConcentrationWithDictionary:(NSDictionary*)dict
{
	Concentration* concentration = [self insertNewObject];
	concentration.name = [dict objectForKey:@"name"];
	
	return concentration;
}


#pragma mark - 
#pragma mark For Table View

+ (NSArray*)concentrationsForName:(NSString*)theName
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", theName];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (NSUInteger)concentrationCountsForName:(NSString*)theName
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", theName];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
	
	return count;
}

+ (NSArray*)possibleValues
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	[request setResultType:NSDictionaryResultType];
	[request setReturnsDistinctResults:YES];
	[request setPropertiesToFetch:[NSArray arrayWithObject:@"name"]];
	
	// Execute the fetch
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
	return results;
}



@end
