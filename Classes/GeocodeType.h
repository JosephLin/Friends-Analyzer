//
//  GeocodeType.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Geocode;

@interface GeocodeType : NSManagedObject {
@private
}
@property (nonatomic, retain) UNKNOWN_TYPE type;
@property (nonatomic, retain) Geocode * geocode;

@end
