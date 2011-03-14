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
#import "Geocode.h"
#import "NSDate+Utilities.h"
#import "LastName.h"

#define kTimeIntervalADay           86400
#define kTimeIntervalAWeek          604800
#define kTimeIntervalAMonth         2592000
#define kTimeIntervalThreeMonths    7776000
#define kTimeIntervalSixMonths      15552000
#define kTimeIntervalAYear          31536000

static NSArray* monthArray = nil;

@implementation User 

@dynamic id;
@dynamic name;
@dynamic first_name;
@dynamic middle_name;
@dynamic lastName;
@dynamic link;
@dynamic birthday;
@dynamic birthdayYear, birthdayMonth, birthdayDay;
@dynamic zodiacSymbol;
@dynamic zodiacName;
@dynamic hometown;
@dynamic location;
@dynamic works;
@dynamic educations;
@dynamic gender;
@dynamic relationship_status;
@dynamic significant_other;
@dynamic locale;
@dynamic updated_time;
@dynamic friends;
@dynamic geocodeHometown;
@dynamic geocodeLocation;

@dynamic age;
@dynamic ageGroup;



#pragma -
#pragma Transient Attributs

- (NSNumber*)age
{
    NSDate* startDate = self.birthday;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:startDate  toDate:[NSDate date] options:0];
    NSInteger years = [components year];
    return [NSNumber numberWithInteger:years];
}

- (NSNumber*)ageGroup
{
    NSDate* startDate = self.birthday;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:startDate  toDate:[NSDate date] options:0];
    NSInteger years = [components year];
    return [NSNumber numberWithInteger:years/10];
}

- (NSString*)lastUpdateCategory
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.updated_time];
    
    if ( interval < kTimeIntervalADay )
    {
        return @"A Day";
    }
    else if ( interval < kTimeIntervalAWeek )
    {
        return @"A Week";        
    }
    else if ( interval < kTimeIntervalAMonth )
    {
        return @"A Month";
    }
    else if ( interval < kTimeIntervalThreeMonths )
    {
        return @"Last Three Months";
    }
    else if ( interval < kTimeIntervalSixMonths )
    {
        return @"Last Six Months";
    }
    else if ( interval < kTimeIntervalAYear )
    {
        return @"A Year";
    }
    else
    {
        return @"More Than A Year";
    }
}


#pragma mark -
#pragma mark Load/Save

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

	user.lastName = [ObjectAttribute entity:@"LastName" withName:[dict objectForKey:@"last_name"]];
	
    user.link = [dict objectForKey:@"link"];
	user.birthday = [NSDate dateFromFacebookBirthday:[dict objectForKey:@"birthday"]];
    [user setBirhtdayWithString:[dict objectForKey:@"birthday"]];
    if ([user.birthdayMonth integerValue] && [user.birthdayDay integerValue])
    {
        [user setZodiac];
    }
    
	id hometown = [[dict objectForKey:@"hometown"] objectForKey:@"name"];
	user.hometown = ( hometown != [NSNull null] ) ? hometown : nil;

	id location = [[dict objectForKey:@"location"] objectForKey:@"name"];
	user.location = ( location != [NSNull null] ) ? location : nil;

	user.gender = [dict objectForKey:@"gender"];
	user.relationship_status = [dict objectForKey:@"relationship_status"];
	user.locale = [dict objectForKey:@"locale"];
	user.updated_time = [NSDate dateFromFacebookFullFormat:[dict objectForKey:@"updated_time"]];
	
	[user updateEducations:[dict objectForKey:@"education"]];

	[user updateWorks:[dict objectForKey:@"work"]];

	
	[self save];
	
	return user;
}

- (void)setZodiac
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Horoscope" ofType:@"plist"];
    if ( !monthArray )
    {
        monthArray = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"Root"] retain];
    }
    
    NSArray* dayArray = [monthArray valueForKeyPath:@"@unionOfObjects.startDay"];
    NSArray* symbolArray = [monthArray valueForKeyPath:@"@unionOfObjects.symbol"];
    NSArray* nameArray = [monthArray valueForKeyPath:@"@unionOfObjects.name"];

    NSInteger index = [self.birthdayMonth integerValue] - 1;
    NSInteger startDay = [[dayArray objectAtIndex:index] integerValue];

    if ( [self.birthdayDay integerValue] < startDay )
    {
        index = index - 1;
    }
    
    if ( index < 0 )
    {
        index = 11;
    }
    
    self.zodiacSymbol = [symbolArray objectAtIndex:index];
    self.zodiacName = [nameArray objectAtIndex:index];
}


- (void)setBirhtdayWithString:(NSString*)birthdayString
{
    NSArray* components = [birthdayString componentsSeparatedByString:@"/"];
    if ( [components count] >= 3 )
    {
        self.birthdayYear = [NSNumber numberWithInteger:[[components objectAtIndex:2] integerValue]];
    }
    if ( [components count] >= 2 )
    {
        self.birthdayMonth = [NSNumber numberWithInteger:[[components objectAtIndex:0] integerValue]];
        self.birthdayDay = [NSNumber numberWithInteger:[[components objectAtIndex:1] integerValue]];
    }
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


#pragma mark - 
#pragma mark For Table View

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
	
/*	
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
 */
}





@end
