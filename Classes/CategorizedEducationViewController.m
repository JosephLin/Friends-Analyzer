//
//  EducationCategorizedTableViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategorizedEducationViewController.h"
#import "Education.h"




@implementation CategorizedEducationViewController
@synthesize property;


- (void)dealloc
{
	[property release];
    [super dealloc];
}


#pragma mark - 
#pragma mark Table View Data Source

- (NSArray*)sortedKeys
{
    if ( !sortedKeys )
    {
        NSArray* possibleKeys = [Education possibleValuesForCategory:property];
        NSString* keyPath = [NSString stringWithFormat:@"@unionOfObjects.%@", property];
        NSArray* keys = [possibleKeys valueForKeyPath:keyPath];
        
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
            NSNumber* count = [NSNumber numberWithInteger:[Education educationCountsForKey:property value:key]];
            [tempDict setObject:count forKey:key];
        }
        
        userCountsDict = [[NSDictionary alloc] initWithDictionary:tempDict];
    }
    return userCountsDict;
}

- (NSArray*)usersForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = [self.sortedKeys objectAtIndex:indexPath.row];
	NSArray* educations = [Education educationsForKey:property value:key];
    NSArray* users = [educations valueForKeyPath:@"@unionOfObjects.user"];
    
	return users;
}


@end