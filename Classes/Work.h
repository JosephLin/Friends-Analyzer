//
//  Work.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"

@class User;

@interface Work :  EnhancedManagedObject  
{
}

@property (nonatomic, retain) NSString * employer;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * start_date;
@property (nonatomic, retain) User * user;

+ (Work*)insertWorkWithDictionary:(NSDictionary*)dict;

@end



