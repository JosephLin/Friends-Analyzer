//
//  LastName.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/13/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"

@class User;

@interface LastName : EnhancedManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * indexTitle;
@property (nonatomic, retain) NSNumber * userCount;
@property (nonatomic, retain) NSSet* users;

+ (id)objectWithName:(NSString*)theName;

@end
