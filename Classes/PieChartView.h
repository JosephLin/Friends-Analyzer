//
//  PieChartView.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartObject.h"


@interface PieChartView : UIView
{
    NSMutableArray* pieChartObjects;
	NSArray* colorScheme;
}

@property (nonatomic, retain) NSMutableArray* pieChartObjects;
@property (nonatomic, retain, readonly) NSArray* colorScheme;

- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values displayNames:(NSArray*)displayNames;
- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values;

@end
