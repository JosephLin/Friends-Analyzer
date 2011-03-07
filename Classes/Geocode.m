//
//  Geocode.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Geocode.h"
#import "LocationName.h"


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

+ (Geocode*)insertGeocodeWithDictionary:(NSDictionary*)dict
{
	Geocode* geocode = [self insertNewObject];
	
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
    
    NSDictionary* location = [[dict objectForKey:@"geometry"] objectForKey:@"location"];
	geocode.latitude = [location objectForKey:@"lat"];
	geocode.longitude = [location objectForKey:@"lng"];
	
	[self save];
	
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








@end
