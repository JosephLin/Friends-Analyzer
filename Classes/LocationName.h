//
//  LocationName.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EnhancedManagedObject.h"


@interface LocationName : EnhancedManagedObject
{

}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject * geoCode;

+ (LocationName*)insertLocationNameWithName:(NSString*)theName;
+ (LocationName*)locationNameForName:(NSString*)theName;

@end
