//
//  Work.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"
#import "ObjectAttribute.h"

@class User;
@class Geocode;

@interface Work :  EnhancedManagedObject  
{
}

@property (nonatomic, strong) ObjectAttribute * employer;
@property (nonatomic, strong) ObjectAttribute * position;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSDate * start_date;
@property (nonatomic, strong) NSDate * end_date;
@property (nonatomic, strong) User * user;
@property (nonatomic, strong) Geocode * geocodeLocation;

+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict;
+ (NSArray*)allWorks;
- (NSString*)workDate;

@end



