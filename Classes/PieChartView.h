//
//  PieChartView.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PieChartView : UIView
{
	NSMutableDictionary* dict;
	NSArray* colorScheme;
}

@property (nonatomic, retain) NSMutableDictionary* dict;
@property (nonatomic, retain) NSArray* colorScheme;

@end
