//
//  NSDate+Utilities.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Utilities)

+ (NSDate*)dateFromFacebookFullFormat:(NSString*)dateString;
+ (NSDate*)dateFromFacebookBirthday:(NSString*)dateString;
+ (NSDate*)dateFromYearMonth:(NSString*)dateString;
- (NSString*)stringFromDate;

@end
