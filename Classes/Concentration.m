// 
//  Concentration.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Concentration.h"


@implementation Concentration 

@dynamic name;
@dynamic educations;

+ (Concentration*)concentrationWithName:(NSString*)theName
{
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:[self entity]];
	
	NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name like[c] %@", theName];
	[request setPredicate:predicate];
	
	NSError* error = nil;
	NSArray* results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
    if ([results count])
    {
        return [results objectAtIndex:0];
    }
    else
    {
        Concentration* concentration = [self insertNewObject];
        concentration.name = theName;
        return concentration;
    }
}



@end
