//
//  NSDate+Utilities.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Utilities)

+ (NSDate*)dateFromFacebookFormat:(NSString*)dateString;
+ (NSDate*)startDateFromString:(NSString*)dateString;
- (NSDate*)stringFromDate;

@end
