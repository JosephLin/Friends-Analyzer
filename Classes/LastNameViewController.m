//
//  LastNameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/24/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
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
    ObjectAttribute* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* array = [object.owners sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return array;
}



@end
