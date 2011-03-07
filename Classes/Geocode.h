//
//  Geocode.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "EnhancedManagedObject.h"


@class LocationName;

@interface Geocode : EnhancedManagedObject
{
}

@property (nonatomic, retain) NSString * formatted_address;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * administrative_area_level_1;
@property (nonatomic, retain) NSString * administrative_area_level_2;
@property (nonatomic, retain) NSString * administrative_area_level_3;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * sublocality;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet* locationNames;

+ (NSArray*)allGeocodes;
+ (Geocode*)insertGeocodeWithDictionary:(NSDictionary*)dict;
+ (Geocode*)geocodeForName:(NSString*)locationName;

@end


@interface Geocode (CoreDataGeneratedAccessors)
- (void)addLocationNamesObject:(LocationName *)value;
- (void)removeLocationNamesObject:(LocationName *)value;
- (void)addLocationNames:(NSSet *)value;
- (void)removeLocationNames:(NSSet *)value;

@end