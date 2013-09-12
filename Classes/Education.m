// 
//  Education.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "Education.h"

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
	
	education.school = [ObjectAttribute entity:@"School" withName:dict[@"school"][@"name"]];
	education.degree = [ObjectAttribute entity:@"Degree" withName:dict[@"degree"][@"name"]];
	education.year = dict[@"year"][@"name"];
	education.type = dict[@"type"];
	
	NSArray* concentrationArray = dict[@"concentration"];
	for ( id dict in concentrationArray )
	{
        Concentration* concentration = [ObjectAttribute entity:@"Concentration" withName:dict[@"name"]];
        [education addConcentrationsObject:concentration];
	}
	
	return education;
}



#pragma mark - 
#pragma mark For Table View

+ (NSArray*)educationsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (NSUInteger)educationCountsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
	
	return count;
}

+ (NSArray*)possibleValuesForCategory:(NSString*)category
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	[request setResultType:NSDictionaryResultType];
	[request setReturnsDistinctResults:YES];
	[request setPropertiesToFetch:@[category]];
	
	// Execute the fetch
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
	return results;
}



@end
