//
//  Geocode.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"
#import <CoreLocation/CoreLocation.h>

#define kUnknownGeocodeCoordinate  99999


@class LocationName;
@class User;
@class Work;

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
@property (nonatomic, retain) NSSet * locationNames;
@property (nonatomic, retain) NSSet * userHometowns;
@property (nonatomic, retain) NSSet * userLocations;
@property (nonatomic, retain) NSSet * workLocations;

+ (Geocode*)geocodeWithLatitude:(NSNumber*)latitude longitude:(NSNumber*)longitude;
+ (Geocode*)existingOrNewGeocodeWithDictionary:(NSDictionary*)dict;
+ (Geocode*)existingOrNewGeocodeWithpPlacemark:(CLPlacemark*)placemark;
+ (Geocode*)geocodeForName:(NSString*)locationName;
+ (NSArray*)allGeocodes;
+ (Geocode*)unknownGeocode;
- (CLLocationCoordinate2D)coordinate;
- (NSString*)shortName;

@end


@interface Geocode (CoreDataGeneratedAccessors)
- (void)addLocationNamesObject:(LocationName *)value;
- (void)removeLocationNamesObject:(LocationName *)value;
- (void)addLocationNames:(NSSet *)value;
- (void)removeLocationNames:(NSSet *)value;

@end