// 
//  Concentration.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Concentration.h"


@implementation Concentration 

@dynamic name;
@dynamic education;

+ (Concentration*)insertConcentrationWithDictionary:(NSDictionary*)dict
{
	Concentration* concentration = [self insertNewObject];
	concentration.name = [dict objectForKey:@"name"];
	
	return concentration;
}

@end
