//
//  School.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import "School.h"
#import "Education.h"


@implementation School
@dynamic owners;

- (void)addOwnersObject:(Education *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"owners"] addObject:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeOwnersObject:(Education *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"owners"] removeObject:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addOwners:(NSSet *)value {    
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"owners"] unionSet:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeOwners:(NSSet *)value {
    [self willChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"owners"] minusSet:value];
    [self didChangeValueForKey:@"owners" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
