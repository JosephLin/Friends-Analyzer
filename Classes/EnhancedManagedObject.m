//
//  EnhancedManagedObject.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "EnhancedManagedObject.h"
#import "FriendsAnalyzerAppDelegate.h"

@implementation EnhancedManagedObject


+ (NSManagedObjectContext*)managedObjectContext
{
	return [(FriendsAnalyzerAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (NSEntityDescription*)entity
{
	NSString* entityName = NSStringFromClass([self class]);
	return [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
}

+ (id)insertNewObject
{
	NSString* entityName = NSStringFromClass([self class]);
	id newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self managedObjectContext]];
	return newObject;
}

+ (void)save
{
	NSError* error = nil;
	[[self managedObjectContext] save:&error];

	if ( error )
	{
		NSLog(@"Failed to save object: %@", self);
		NSLog(@"Error: %@", error);
	}
	
}

@end
