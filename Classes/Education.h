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

@property (nonatomic, strong) ObjectAttribute * school;
@property (nonatomic, strong) ObjectAttribute * degree;
@property (nonatomic, strong) NSString * year;
@property (nonatomic, strong) NSSet* concentrations;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) User * user;

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

