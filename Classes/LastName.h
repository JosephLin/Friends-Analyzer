//
//  LastName.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/14/11.
//  Copyright (c) 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastName : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * indexTitle;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * ownerCount;

@end
