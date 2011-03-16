//
//  PositionViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PositionViewController.h"


@implementation PositionViewController


- (void)viewDidLoad
{    
    self.entityName = @"Position";
    
    [super viewDidLoad];
}

- (NSArray*)usersForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"user.name" ascending:YES];
    NSArray* sorted = [object.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    NSArray* array = [sorted valueForKeyPath:@"@unionOfObjects.user"];
    
    return array;
}


@end
