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
        
        [self save];
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

- (NSArray*)users
{
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[User entity]];
	
    NSArray* names = [self.locationNames valueForKeyPath:@"@distinctUnionOfObjects.name"];
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"hometown IN %@", names];
	[request setPredicate:predicate];
	
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	return results;
}



#pragma mark -
#pragma mark MKAnnotation Protocal

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees latitude = [self.latitude doubleValue];
	CLLocationDegrees longitude = [self.longitude doubleValue];
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (NSString *)title
{
	return self.formatted_address;
}

- (NSString *)subtitle
{
    NSArray* users = [self users];
    return [NSString stringWithFormat:@"%d", [users count]];
}





@end