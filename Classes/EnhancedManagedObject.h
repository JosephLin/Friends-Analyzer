//
//  EnhancedManagedObject.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EnhancedManagedObject : NSManagedObject {

}

+ (NSManagedObjectContext*)managedObjectContext;
+ (NSEntityDescription*)entity;
+ (id)insertNewObject;
+ (void)save;

@end
