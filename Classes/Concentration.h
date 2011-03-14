//
//  Concentration.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LastName.h"

@class Education;

@interface Concentration : LastName {
@private
}
@property (nonatomic, retain) NSSet* owners;

@end
