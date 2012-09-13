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

@property (nonatomic, strong) NSString * formatted_address;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * administrative_area_level_1;
@property (nonatomic, strong) NSString * administrative_area_level_2;
@property (nonatomic, strong) NSString * administrative_area_level_3;
@property (nonatomic, strong) NSString * locality;
@property (nonatomic, strong) NSString * sublocality;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSSet * locationNames;
@property (nonatomic, strong) NSSet * userHometowns;
@property (nonatomic, strong) NSSet * userLocations;
@property (nonatomic, strong) NSSet * workLocations;

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