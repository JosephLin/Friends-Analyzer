//
//  ConcentrationViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConcentrationViewController.h"
#import "Education.h"
#import "Concentration.h"

@implementation ConcentrationViewController


#pragma mark - 
#pragma mark Table View Data Source

- (NSArray*)sortedKeys
{
    if ( !sortedKeys )
    {
        NSArray* possibleKeys = [Concentration possibleValues];
        NSArray* keys = [possibleKeys valueForKeyPath:@"@unionOfObjects.name"];
        
        if ( self.segmentedControl.selectedSegmentIndex == 0 )
        {
            sortedKeys = [keys retain];
        }
        else
        {
            sortedKeys = [[keys sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
                return [[userCountsDict objectForKey:obj1] intValue] < [[userCountsDict objectForKey:obj2] intValue];
            }] retain];
        }
    }
    return sortedKeys;
}

- (NSDictionary*)userCountsDict
{
    if ( !userCountsDict )
    {
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:[self.sortedKeys count]];
        
        for ( id key in sortedKeys )
        {
            NSNumber* count = [NSNumber numberWithInteger:[Concentration concentrationCountsForName:key]];
            [tempDict setObject:count forKey:key];
        }
        
        userCountsDict = [[NSDictionary alloc] initWithDictionary:tempDict];
    }
    return userCountsDict;
}

- (NSArray*)usersForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
	NSArray* concentrations = [Concentration concentrationsForName:key];
    NSArray* users = [concentrations valueForKeyPath:@"@unionOfObjects.education.user"];
    
	return users;
}

@end
