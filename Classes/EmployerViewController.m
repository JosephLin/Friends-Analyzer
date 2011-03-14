//
//  EmployerViewController.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EmployerViewController.h"


@implementation EmployerViewController


- (void)viewDidLoad
{    
    self.entityName = @"Employer";
    
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
