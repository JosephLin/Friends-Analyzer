//
//  Work.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"
#import "ObjectAttribute.h"

@class User;
@class Geocode;

@interface Work :  EnhancedManagedObject  
{
}

@property (nonatomic, retain) ObjectAttribute * employer;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) User * user;
@property (nonatomic, retain) Geocode * geocodeLocation;

+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict;

@end



