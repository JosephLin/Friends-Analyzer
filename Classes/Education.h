//
//  Education.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"
#import "ObjectAttribute.h"

@class Concentration;
@class User;

@interface Education :  EnhancedManagedObject  
{
}

@property (nonatomic, retain) ObjectAttribute * school;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSSet* concentrations;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) User * user;

+ (Education*)insertEducationWithDictionary:(NSDictionary*)dict;
+ (NSArray*)educationsForKey:(NSString*)key value:(NSString*)value;
+ (NSUInteger)educationCountsForKey:(NSString*)key value:(NSString*)value;
+ (NSArray*)possibleValuesForCategory:(NSString*)category;

@end


@interface Education (CoreDataGeneratedAccessors)
- (void)addConcentrationsObject:(Concentration *)value;
- (void)removeConcentrationsObject:(Concentration *)value;
- (void)addConcentrations:(NSSet *)value;
- (void)removeConcentrations:(NSSet *)value;

@end

