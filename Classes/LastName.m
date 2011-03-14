//
//  LastName.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/13/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "LastName.h"
#import "User.h"


@implementation LastName
@dynamic name;
@dynamic indexTitle;
@dynamic userCount;
@dynamic users;




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
        LastName* object = [self insertNewObject];
        object.name = theName;
        return object;
    }
}

- (NSString*)indexTitle
{
    NSString* string = [self.name substringToIndex:1];
    return string;
}





- (void)addUsersObject:(User *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"users" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"users"] addObject:value];
    [self didChangeValueForKey:@"users" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
    
    self.userCount = [NSNumber numberWithInteger:[self.users count]];
}

- (void)removeUsersObject:(User *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"users" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"users"] removeObject:value];
    [self didChangeValueForKey:@"users" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];

    self.userCount = [NSNumber numberWithInteger:[self.users count]];
}

- (void)addUsers:(NSSet *)value {    
    [self willChangeValueForKey:@"users" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"users"] unionSet:value];
    [self didChangeValueForKey:@"users" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];

    self.userCount = [NSNumber numberWithInteger:[self.users count]];
}

- (void)removeUsers:(NSSet *)value {
    [self willChangeValueForKey:@"users" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"users"] minusSet:value];
    [self didChangeValueForKey:@"users" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];

    self.userCount = [NSNumber numberWithInteger:[self.users count]];
}


@end
