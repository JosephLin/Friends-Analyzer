//
//  LastNameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LastNameViewController.h"


@implementation LastNameViewController


- (void)viewDidLoad
{    
    self.entityName = @"LastName";
    
    [super viewDidLoad];
}

- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObjectAttribute* object = [fetchedResultsController objectAtIndexPath:indexPath];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* array = [object.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return array;
}



@end
