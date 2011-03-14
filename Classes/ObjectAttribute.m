//
//  ObjectAttribute.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/13/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "ObjectAttribute.h"


@implementation ObjectAttribute

@dynamic name;
@dynamic indexTitle;
@dynamic ownerCount;
@dynamic owners;


+ (id)objectWithName:(NSString*)theName
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
        ObjectAttribute* object = [self insertNewObject];
        object.name = theName;
        return object;
    }
}

- (NSString*)indexTitle
{
    NSString* string = [self.name substringToIndex:1];
    return string;
}

- (void)addOwnersObject:(NSManagedObject*)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"owners"] addObject:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
    
    self.ownerCount = [NSNumber numberWithInteger:[self.owners count]];
}

- (void)removeOwnersObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"owners"] removeObject:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
    
    self.ownerCount = [NSNumber numberWithInteger:[self.owners count]];
}

- (void)addOwners:(NSSet *)value {    
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"owners"] unionSet:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    
    self.ownerCount = [NSNumber numberWithInteger:[self.owners count]];
}

- (void)removeOwners:(NSSet *)value {
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"owners"] minusSet:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    
    self.ownerCount = [NSNumber numberWithInteger:[self.owners count]];
}

@end


