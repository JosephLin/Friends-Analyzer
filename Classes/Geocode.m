//
//  Geocode.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Geocode.h"
#import "LocationName.h"
#import "User.h"
#import "Work.h"

@implementation Geocode

@dynamic formatted_address;
@dynamic country;
@dynamic administrative_area_level_1;
@dynamic administrative_area_level_2;
@dynamic administrative_area_level_3;
@dynamic locality;
@dynamic sublocality;
@dynamic latitude;
@dynamic longitude;
@dynamic locationNames;
@dynamic userHometowns;
@dynamic userLocations;
@dynamic workLocations;



#pragma mark -
#pragma mark Load/Save

+ (NSArray*)allGeocodes
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (Geocode*)geocodeWithLatitude:(NSNumber*)latitude longitude:(NSNumber*)longitude
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude, longitude];
	[request setPredicate:predicate];
    
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    Geocode* geocode = ([results count]) ? results[0] : nil;
	return geocode;
}

+ (Geocode*)existingOrNewGeocodeWithDictionary:(NSDictionary*)dict
{
    NSDictionary* location = dict[@"geometry"][@"location"];
	NSNumber* latitude = location[@"lat"];
	NSNumber* longitude = location[@"lng"];

    Geocode* geocode = [self geocodeWithLatitude:latitude longitude:longitude];
	
	if ( !geocode )
	{
		geocode = [self insertNewObject];
        
        geocode.latitude = latitude;
        geocode.longitude = longitude;
        geocode.formatted_address = dict[@"formatted_address"];

        NSArray* address_components = dict[@"address_components"];
        for ( NSDictionary* address_component in address_components )
        {
            NSString* long_name = address_component[@"long_name"];
            NSArray* types = address_component[@"types"];
            for ( NSString* type in types )
            {
                //// "setValue:forUndefinedKey:" will catch invalid keys and ignores them. ////
                [geocode setValue:long_name forKeyPath:type];
            }
        }
    }
	
	return geocode;
}


+ (Geocode*)existingOrNewGeocodeWithpPlacemark:(CLPlacemark*)placemark
{
	NSNumber* latitude = @(placemark.location.coordinate.latitude);
	NSNumber* longitude = @(placemark.location.coordinate.longitude);
    
    Geocode* geocode = [self geocodeWithLatitude:latitude longitude:longitude];
	
	if ( !geocode )
	{
		geocode = [self insertNewObject];
        
        geocode.latitude = latitude;
        geocode.longitude = longitude;
        geocode.formatted_address = (placemark.addressDictionary)[@"FormattedAddressLines"][0];
        
        
        
        geocode.country = placemark.country;
        geocode.administrative_area_level_1 = placemark.administrativeArea;
        geocode.administrative_area_level_2 = placemark.subAdministrativeArea;
        geocode.locality = placemark.locality;
        geocode.sublocality = placemark.subLocality;

    }
	
	return geocode;
}



+ (Geocode*)geocodeForName:(NSString*)locationName
{
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY locationNames.name == %@", locationName];
	[request setPredicate:predicate];
    
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    Geocode* geocode = ([results count]) ? results[0] : nil;
	return geocode;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}

+ (Geocode*)unknownGeocode
{
    NSNumber* unknownCoordinate = @kUnknownGeocodeCoordinate;
    Geocode* geocode = [self geocodeWithLatitude:unknownCoordinate longitude:unknownCoordinate];
	
	if ( !geocode )
	{
		geocode = [self insertNewObject];
        
        geocode.latitude = unknownCoordinate;
        geocode.longitude = unknownCoordinate;
        geocode.formatted_address = @"Unknown";
        geocode.country = @"Unknown";
        
//        [self save];
    }
	
	return geocode;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees latitude = [self.latitude doubleValue];
	CLLocationDegrees longitude = [self.longitude doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString*)shortName
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:5];
    if ( self.sublocality )
        [array addObject:self.sublocality];
    if ( self.locality )
        [array addObject:self.locality];
    if ( self.administrative_area_level_3 )
        [array addObject:self.administrative_area_level_3];
    if ( self.administrative_area_level_2 )
        [array addObject:self.administrative_area_level_2];
    if ( self.administrative_area_level_1 )
        [array addObject:self.administrative_area_level_1];
    
    NSString* string = [array componentsJoinedByString:@", "];

    if ( ![string length] )
        string = self.country;
    
    return string;
}



@end
