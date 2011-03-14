//
//  ObjectAttribute.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/13/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnhancedManagedObject.h"

@interface ObjectAttribute : EnhancedManagedObject
{
    
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * indexTitle;
@property (nonatomic, retain) NSNumber * ownerCount;
@property (nonatomic, retain) NSSet* owners;

+ (id)objectWithName:(NSString*)theName;

@end