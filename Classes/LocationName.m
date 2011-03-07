//
//  LocationName.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationName.h"


@implementation LocationName
@dynamic name;
@dynamic geoCode;


+ (LocationName*)insertLocationNameWithName:(NSString*)theName
{
	LocationName* locationName = [self insertNewObject];
	
    locationName.name = theName;

	[self save];
	
	return locationName;
}

+ (LocationName*)locationNameForName:(NSString*)theName
{
    NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", theName];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    LocationName* locationName = ([results count]) ? [results objectAtIndex:0] : nil;
	return locationName;
}


@end
