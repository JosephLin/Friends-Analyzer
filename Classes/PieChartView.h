//
//  PieChartView.h
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieChartObject.h"


@interface PieChartView : UIView
{
    NSMutableArray* pieChartObjects;
	NSArray* colorScheme;
}

@property (nonatomic, strong) NSMutableArray* pieChartObjects;
@property (nonatomic, strong, readonly) NSArray* colorScheme;

- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values displayNames:(NSArray*)displayNames;
- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values;

@end
