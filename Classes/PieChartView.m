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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	NSNumber* valueSum = [[dict allValues] valueForKeyPath:@"@sum.intValue"];
	NSInteger total = [valueSum intValue];
	CGFloat startValue = 0;
	
    
	CGFloat radius = ( MIN( rect.size.width , rect.size.height ) / 2 ) * 0.8;
	CGFloat centerX = rect.size.width / 2;
	CGFloat centerY = self.bounds.size.height - radius - 10.0;

    
    CGFloat labelX = 15.0;
    CGFloat labelY = 15.0;
    
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
	
	int colorIndex = 0;
	for ( NSString* key in [dict allKeys] )
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
        
        // Draw Label
        CGRect squareFrame = CGRectMake(labelX, labelY, 10.0, 10.0);
        CGContextFillRect(context, squareFrame);

        CGRect labelFrame = CGRectMake(labelX + 15.0, labelY, 200.0, 15.0);
        [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:12.0]];
        
        
        // Set next start point
        startValue = endValue;
        labelY += 20.0;
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
