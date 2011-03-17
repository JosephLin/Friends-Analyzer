//
//  NameViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/2/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "NameViewController.h"


@implementation NameViewController


- (void)viewDidLoad
{    
    self.entityName = @"LastName";
    
    [super viewDidLoad];
}

- (NSArray*)objectsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObjectAttribute* object = [fetchedResultController objectAtIndexPath:indexPath];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray* array = [object.owners sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return array;
}



@end
