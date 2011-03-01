// 
//  Education.m
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/1/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "Education.h"

#import "Concentration.h"
#import "User.h"

@implementation Education 

@dynamic school;
@dynamic degree;
@dynamic year;
@dynamic concentrations;
@dynamic type;
@dynamic user;


+ (Education*)insertEducationWithDictionary:(NSDictionary*)dict
{
	Education* education = [self insertNewObject];
	
	education.school = [[dict objectForKey:@"school"] objectForKey:@"name"];
	education.degree = [[dict objectForKey:@"degree"] objectForKey:@"name"];
	education.year = [[dict objectForKey:@"year"] objectForKey:@"name"];
	education.type = [dict objectForKey:@"type"];
	
	NSArray* concentrationArray = [dict objectForKey:@"concentration"];
	for ( id dict in concentrationArray )
	{
		[education addConcentrationsObject:[Concentration insertConcentrationWithDictionary:dict]];
	}
	
	return education;
}


@end
