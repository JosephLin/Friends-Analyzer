//
//  User.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"

typedef enum {
    LastUpdateCategoryNone = 0,
    LastUpdateCategoryADay,
    LastUpdateCategoryAWeek,
    LastUpdateCategoryAMonth,
    LastUpdateCategoryThreeMonths,
    LastUpdateCategorySixMonths,
    LastUpdateCategoryAYear,
    LastUpdateCategoryMoreThanAYear
} LastUpdateCategory;



@class Geocode;

@interface User :  EnhancedManagedObject  
{
}

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * middle_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSNumber * birthdayYear;
@property (nonatomic, retain) NSNumber * birthdayMonth;
@property (nonatomic, retain) NSNumber * birthdayDay;
@property (nonatomic, retain) NSString * zodiacSymbol;
@property (nonatomic, retain) NSString * zodiacName;
@property (nonatomic, retain) NSString * hometown;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSSet * works;
@property (nonatomic, retain) NSSet* educations;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * relationship_status;
@property (nonatomic, retain) NSManagedObject * significant_other;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSDate * updated_time;
@property (nonatomic, retain) NSArray * friends;
@property (nonatomic, retain) Geocode * geocodeHometown;
@property (nonatomic, retain) Geocode * geocodeLocation;

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * ageGroup;
@property (nonatomic, retain, readonly) NSString* lastUpdateCategory;


+ (User*)userWithID:(NSString*)theID;
+ (User*)existingOrNewUserWithDictionary:(NSDictionary*)dict;
+ (User*)currentUser;
+ (NSArray*)allUsers;
+ (NSArray*)usersForKey:(NSString*)key value:(NSString*)value;
+ (NSUInteger)userCountsForKey:(NSString*)key value:(NSString*)value;
+ (NSArray*)possibleValuesForCategory:(NSString*)category;

- (void)setBirhtdayWithString:(NSString*)birthdayString;
- (void)setZodiac;
- (void)updateEducations:(NSArray*)newEducations;
- (void)updateWorks:(NSArray*)newWorks;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addEducationsObject:(NSManagedObject *)value;
- (void)removeEducationsObject:(NSManagedObject *)value;
- (void)addEducations:(NSSet *)value;
- (void)removeEducations:(NSSet *)value;

- (void)addWorksObject:(NSManagedObject *)value;
- (void)removeWorksObject:(NSManagedObject *)value;
- (void)addWorks:(NSSet *)value;
- (void)removeWorks:(NSSet *)value;

@end

