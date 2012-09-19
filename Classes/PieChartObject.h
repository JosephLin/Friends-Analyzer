//
//  PieChartObject.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/29/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PieChartObject : NSObject

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, strong) NSString* displayName;

- (id)initWithKey:(NSString*)theKey value:(NSString*)theValue displayName:(NSString*)theName;

@end
