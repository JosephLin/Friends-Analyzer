//
//  Concentration.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"

@interface Concentration :  EnhancedManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject * education;

+ (Concentration*)insertConcentrationWithDictionary:(NSDictionary*)dict;

@end



