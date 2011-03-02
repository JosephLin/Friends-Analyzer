// 
//  User.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "User.h"
#import "Education.h"
#import "Work.h"
#import "NSDate+Utilities.h"


@implementation User 

@dynamic id;
@dynamic name;
@dynamic first_name;
@dynamic middle_name;
@dynamic last_name;
@dynamic link;
@dynamic birthday;
@dynamic hometown;
@dynamic location;
@dynamic works;
@dynamic educations;
@dynamic gender;
@dynamic relationship_status;
@dynamic significant_other;
@dynamic timezone;
@dynamic locale;
@dynamic updated_time;
@dynamic friends;


#pragma mark -
#pragma mark Load/Save

+ (User*)userWithID:(NSString*)theID
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %@", theID];
	[request setPredicate:predicate];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	User* user = ( [results count] ) ? [results objectAtIndex:0] : nil;
	
	return user;
}

+ (User*)existingOrNewUserWithDictionary:(NSDictionary*)dict
{
	User* user = [self userWithID:[dict objectForKey:@"id"]];
	
	if ( !user )
	{
		user = [self insertNewObject];
	}
	
	user.id = [dict objectForKey:@"id"];
	user.name = [dict objectForKey:@"name"];
	user.first_name = [dict objectForKey:@"first_name"];
	user.middle_name = [dict objectForKey:@"middle_name"];
	user.last_name = [dict objectForKey:@"last_name"];
	user.link = [dict objectForKey:@"link"];
	user.birthday = [NSDate dateFromFacebookFormat:[dict objectForKey:@"birthday"]];
	
	id hometown = [[dict objectForKey:@"hometown"] objectForKey:@"name"];
	user.hometown = ( hometown != [NSNull null] ) ? hometown : nil;

	id location = [[dict objectForKey:@"location"] objectForKey:@"name"];
	user.location = ( location != [NSNull null] ) ? location : nil;

	user.gender = [dict objectForKey:@"gender"];
	user.relationship_status = [dict objectForKey:@"relationship_status"];
	user.timezone = [NSNumber numberWithInteger:[[dict objectForKey:@"timezone"] integerValue]];
	user.locale = [dict objectForKey:@"locale"];
	user.updated_time = [NSDate dateFromFacebookFormat:[dict objectForKey:@"updated_time"]];
	
	[user updateEducations:[dict objectForKey:@"education"]];

	[user updateWorks:[dict objectForKey:@"work"]];

	
	[self save];
	
	return user;
}

- (void)updateEducations:(NSArray*)newEducations
{
	//// Remove old ones ////
	for ( Education* education in self.educations )
	{
		[[self managedObjectContext] deleteObject:education];
	}
	
	//// Add new ones ////
	for ( id newEducation in newEducations )
	{
		[self addEducationsObject:[Education insertEducationWithDictionary:newEducation]];
	}
}

- (void)updateWorks:(NSArray*)newWorks
{
	//// Remove old ones ////
	for ( Work* work in self.works )
	{
		[[self managedObjectContext] deleteObject:work];
	}
	
	//// Add new ones ////
	for ( id newWork in newWorks )
	{
		[self addWorksObject:[Work insertWorkWithDictionary:newWork]];
	}
}

+ (NSArray*)usersForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (NSUInteger)userCountsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSUInteger count = [[self managedObjectContext] countForFetchRequest:request error:&error];
	
	return count;
}

+ (NSArray*)allUsers
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (User*)currentUser
{
	NSString* currentUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUserID"];
	return (currentUserID) ? [self userWithID:currentUserID] : nil;
}

+ (NSArray*)possibleValuesForCategory:(NSString*)category
{
	NSArray* results = nil;
	
	if ( [category isEqualToString:@"degree"] )
	{
		NSArray* educationArray = [[self allUsers] valueForKeyPath:@"@distinctUnionOfObjects.educations"];
		results = [educationArray valueForKeyPath:@"@distinctUnionOfSets.degree.name"];
	}
	else
	{
		results = [[self allUsers] valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", category]];
	}
	
	NSArray* sorted = [results sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
		return [obj1 caseInsensitiveCompare:obj2]; }];
	return sorted;
}


@end
