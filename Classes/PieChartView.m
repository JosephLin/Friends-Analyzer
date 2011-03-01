//
//  PieChartView.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "PieChartView.h"
#import "UIColor-Expanded.h"

@implementation PieChartView

@synthesize dict, colorScheme;



- (void)drawRect:(CGRect)rect
{
	NSNumber* valueSum = [[dict allValues] valueForKeyPath:@"@sum"];
	NSInteger total = [valueSum intValue];
	CGFloat startValue = 0;
	
	CGFloat centerX = self.center.x;
	CGFloat centerY = self.center.y;
	CGFloat radius = MIN( self.bounds.size.width , self.bounds.size.height ) / 2;

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
	
	int colorIndex = 0;
	for ( id key in [dict allKeys] )
	{
		NSInteger value = [[dict objectForKey:key] intValue];
		
		UIColor* color = [self.colorScheme objectAtIndex:colorIndex];
		colorIndex = ( colorIndex + 1 ) % [colorScheme count];
		
		[color setStroke];
		[color setFill];
		
		CGFloat endValue = startValue + value;
		
		CGFloat startAngle = 2 * M_PI * startValue / total;
		CGFloat endAngle = 2 * M_PI * endValue / total;
		
		// Draw pie
		CGContextAddArc(context, centerX, centerY, radius, startAngle - M_PI_2, endAngle - M_PI_2, NO);
		CGContextAddLineToPoint(context, centerX, centerY);
		CGContextDrawPath(context, kCGPathFill);
	}

	UIGraphicsPopContext();
}

- (void)dealloc
{
	[dict release];
	[colorScheme release];
    [super dealloc];
}

- (NSArray*)colorScheme
{
	if ( !colorScheme )
	{
		NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PieChartColorScheme" ofType:@"plist"];
		NSArray* plistArray = [NSArray arrayWithContentsOfFile:plistPath];
		NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:[plistArray count]];
		
		for ( NSString* hexString in plistArray )
		{
			UIColor* color = [UIColor colorWithHexString:hexString];
			[tempArray addObject:color];
		}
		colorScheme = [[NSArray alloc] initWithArray:tempArray];
	}
	return colorScheme;
}

@end
