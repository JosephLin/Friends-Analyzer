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
@class lastName;
@class ObjectAttribute;

@interface User :  EnhancedManagedObject  
{
}

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * first_name;
@property (nonatomic, strong) NSString * middle_name;
@property (nonatomic, strong) ObjectAttribute * lastName;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) NSNumber * birthdayYear;
@property (nonatomic, strong) NSNumber * birthdayMonth;
@property (nonatomic, strong) NSNumber * birthdayDay;
@property (nonatomic, strong) NSString * zodiacSymbol;
@property (nonatomic, strong) NSString * zodiacName;
@property (nonatomic, strong) NSString * hometown;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSSet * works;
@property (nonatomic, strong) NSSet* educations;
@property (nonatomic, strong) NSString * gender;
@property (nonatomic, strong) NSString * relationship_status;
@property (nonatomic, strong) NSManagedObject * significant_other;
@property (nonatomic, strong) NSString * locale;
@property (nonatomic, strong) NSDate * updated_time;
@property (nonatomic, strong) NSArray * friends;
@property (nonatomic, strong) Geocode * geocodeHometown;
@property (nonatomic, strong) Geocode * geocodeLocation;

@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSNumber * ageGroup;
@property (nonatomic, strong, readonly) NSString* lastUpdateCategory;
@property (nonatomic, strong, readonly) NSString* indexTitle;


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

+ (NSString*)lastUpdateCategoryIndexTitleForString:(NSString*)string;
- (NSArray*)sortedWorks;
- (NSArray*)sortedEducations;

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

