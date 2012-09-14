//
//  ObjectAttribute.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/13/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnhancedManagedObject.h"

@interface ObjectAttribute : EnhancedManagedObject
{
    
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * indexTitle;
@property (nonatomic, strong) NSNumber * ownerCount;
@property (nonatomic, strong) NSSet* owners;

+ (id)entity:(NSString*)entity withName:(NSString*)theName;

@end