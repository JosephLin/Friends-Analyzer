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
    return @(years);
}

- (NSNumber*)ageGroup
{
    NSDate* startDate = self.birthday;
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:startDate  toDate:[NSDate date] options:0];
    NSInteger years = [components year];
    return @(years/10);
}

- (NSString*)lastUpdateCategory
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.updated_time];
    
    if ( interval < kTimeIntervalADay )
    {
        return @"Today";
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

+ (NSString*)lastUpdateCategoryIndexTitleForString:(NSString*)string
{
    if ( [string isEqualToString: @"Today"] )
    {
        return @"D";
    }
    else if ( [string isEqualToString: @"A Week"] )
    {
        return @"W";        
    }
    else if ( [string isEqualToString: @"A Month"] )
    {
        return @"1M";
    }
    else if ( [string isEqualToString: @"Last Three Months"] )
    {
        return @"3M";
    }
    else if ( [string isEqualToString: @"Last Six Months"] )
    {
        return @"6M";
    }
    else if ( [string isEqualToString: @"A Year"] )
    {
        return @"Y";
    }
    else
    {
        return @">Y";
    }
}



#pragma mark -
#pragma mark Load/Save

+ (NSArray*)allUsers
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
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
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %@", theID];
	[request setPredicate:predicate];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];

	User* user = ( [results count] ) ? results[0] : nil;
	
	return user;
}

+ (User*)existingOrNewUserWithDictionary:(NSDictionary*)dict
{
	User* user = [self userWithID:dict[@"id"]];
	
	if ( !user )
	{
		user = [self insertNewObject];
	}
	
	user.id = dict[@"id"];
	user.name = dict[@"name"];
	user.first_name = dict[@"first_name"];
	user.middle_name = dict[@"middle_name"];

	user.lastName = [ObjectAttribute entity:@"LastName" withName:dict[@"last_name"]];
	
    user.link = dict[@"link"];
	user.birthday = [NSDate dateFromFacebookBirthday:dict[@"birthday"]];
    [user setBirhtdayWithString:dict[@"birthday"]];
    if ([user.birthdayMonth integerValue] && [user.birthdayDay integerValue])
    {
        [user setZodiac];
    }
    
	id hometown = dict[@"hometown"][@"name"];
	user.hometown = ( hometown != [NSNull null] ) ? hometown : nil;

	id location = dict[@"location"][@"name"];
	user.location = ( location != [NSNull null] ) ? location : nil;

	user.gender = dict[@"gender"];
	user.relationship_status = dict[@"relationship_status"];
	user.locale = dict[@"locale"];
	user.updated_time = [NSDate dateFromFacebookFullFormat:dict[@"updated_time"]];
	
	[user updateEducations:dict[@"education"]];

	[user updateWorks:dict[@"work"]];

	
//	[self save];
	
	return user;
}

- (void)setZodiac
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Horoscope" ofType:@"plist"];
    if ( !monthArray )
    {
        monthArray = [NSDictionary dictionaryWithContentsOfFile:path][@"Root"];
    }
    
    NSArray* dayArray = [monthArray valueForKeyPath:@"@unionOfObjects.startDay"];
    NSArray* symbolArray = [monthArray valueForKeyPath:@"@unionOfObjects.symbol"];
    NSArray* nameArray = [monthArray valueForKeyPath:@"@unionOfObjects.name"];

    NSInteger index = [self.birthdayMonth integerValue] - 1;
    NSInteger startDay = [dayArray[index] integerValue];

    if ( [self.birthdayDay integerValue] < startDay )
    {
        index = index - 1;
    }
    
    if ( index < 0 )
    {
        index = 11;
    }
    
    self.zodiacSymbol = symbolArray[index];
    self.zodiacName = nameArray[index];
}


- (void)setBirhtdayWithString:(NSString*)birthdayString
{
    NSArray* components = [birthdayString componentsSeparatedByString:@"/"];
    if ( [components count] >= 3 )
    {
        self.birthdayYear = @([components[2] integerValue]);
    }
    if ( [components count] >= 2 )
    {
        self.birthdayMonth = @([components[0] integerValue]);
        self.birthdayDay = @([components[1] integerValue]);
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
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (NSUInteger)userCountsForKey:(NSString*)key value:(NSString*)value
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", key, value];
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

- (NSString*)indexTitle
{
    NSString* string = [self.name substringToIndex:1];
    return string;
}

- (NSArray*)sortedWorks
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"start_date" ascending:YES];
    NSArray* array = [self.works sortedArrayUsingDescriptors:@[sortDescriptor]];
    return array;
}

- (NSArray*)sortedEducations
{
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"year" ascending:NO];
    NSArray* array = [self.educations sortedArrayUsingDescriptors:@[sortDescriptor]];
    return array;
}

@end
