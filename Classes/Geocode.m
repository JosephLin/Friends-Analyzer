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
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSError* error;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}

+ (Geocode*)geocodeWithLatitude:(NSNumber*)latitude longitude:(NSNumber*)longitude
{
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"latitude == %@ AND longitude == %@", latitude, longitude];
	[request setPredicate:predicate];
    
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    Geocode* geocode = ([results count]) ? [results objectAtIndex:0] : nil;
	return geocode;
}

+ (Geocode*)existingOrNewGeocodeWithDictionary:(NSDictionary*)dict
{
    NSDictionary* location = [[dict objectForKey:@"geometry"] objectForKey:@"location"];
	NSNumber* latitude = [location objectForKey:@"lat"];
	NSNumber* longitude = [location objectForKey:@"lng"];

    Geocode* geocode = [self geocodeWithLatitude:latitude longitude:longitude];
	
	if ( !geocode )
	{
		geocode = [self insertNewObject];
        
        geocode.latitude = latitude;
        geocode.longitude = longitude;
        geocode.formatted_address = [dict objectForKey:@"formatted_address"];

        NSArray* address_components = [dict objectForKey:@"address_components"];
        for ( NSDictionary* address_component in address_components )
        {
            NSString* long_name = [address_component objectForKey:@"long_name"];
            NSArray* types = [address_component objectForKey:@"types"];
            for ( NSString* type in types )
            {
                //// "setValue:forUndefinedKey:" will catch invalid keys and ignores them. ////
                [geocode setValue:long_name forKeyPath:type];
            }
        }
        
//        [self save];
    }
	
	return geocode;
}

+ (Geocode*)geocodeForName:(NSString*)locationName
{
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ANY locationNames.name == %@", locationName];
	[request setPredicate:predicate];
    
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    Geocode* geocode = ([results count]) ? [results objectAtIndex:0] : nil;
	return geocode;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    return;
}

+ (Geocode*)unknownGeocode
{
    NSNumber* unknownCoordinate = [NSNumber numberWithInt:kUnknownGeocodeCoordinate];
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
