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

- (void)setDict:(NSDictionary*)theDict
{
    [dict autorelease];
    dict = [theDict retain];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIGraphicsPushContext(context);
    {
        //// Draw Background Gradient ////
        CGFloat locations[3] = { 0.0, 0.8, 1.0 };
        CGFloat components[12] = { 
            1.0, 1.0, 1.0, 1.0,
            0.8, 0.8, 0.8, 1.0,
            0.7, 0.7, 0.7, 1.0
        };
        
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, 3);
        
        CGRect currentBounds = self.bounds;
        CGPoint topCenter = CGPointMake( CGRectGetMidX(currentBounds), 0.0f);
        CGPoint bottomCenter = CGPointMake( CGRectGetMidX(currentBounds), CGRectGetHeight(currentBounds));
        CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
        
        CGGradientRelease(glossGradient);
        CGColorSpaceRelease(rgbColorspace);
        
        
        NSNumber* valueSum = [[dict allValues] valueForKeyPath:@"@sum.intValue"];
        NSInteger total = [valueSum intValue];
        CGFloat startValue = 0;
        int colorIndex = 0;

        CGFloat radius = ( MIN( rect.size.width , rect.size.height ) / 2 ) * 0.8;
        CGFloat centerX = CGRectGetMidX(rect);
        CGFloat centerY = CGRectGetMidY(rect);
        
        CGFloat labelX = 15.0;
        CGFloat labelY = 15.0;
        
        NSArray* sortedKeys = [[dict allKeys] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
            if ( [obj1 intValue] )
            {
                return [obj1 intValue] > [obj2 intValue];
            }
            else
            {
                return [obj1 caseInsensitiveCompare:obj2];
            }
        }];
        for ( NSString* key in sortedKeys )
        {
            NSInteger value = [[dict objectForKey:key] intValue];
            
            NSInteger index = colorIndex % [self.colorScheme count];
            CGFloat k = 1 + 0.1 * colorIndex / [self.colorScheme count];
            colorIndex++;
            
            NSDictionary* colorDict = [self.colorScheme objectAtIndex:index];
            CGFloat red = [[colorDict objectForKey:@"red"] floatValue] * k;
            CGFloat green = [[colorDict objectForKey:@"green"] floatValue] * k;
            CGFloat blue = [[colorDict objectForKey:@"blue"] floatValue] * k;
            
			UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
			
//            UIColor* color = [self.colorScheme objectAtIndex:colorIndex];
            [color setStroke];
            [color setFill];
//            colorIndex = ( colorIndex + 1 ) % [colorScheme count];
            
            CGFloat endValue = startValue + value;
            CGFloat startAngle = 2 * M_PI * startValue / total;
            CGFloat endAngle = 2 * M_PI * endValue / total;
            
            // Draw pie
            CGContextAddArc(context, centerX, centerY, radius, startAngle - M_PI_2, endAngle - M_PI_2, NO);
            CGContextAddLineToPoint(context, centerX, centerY);
            CGContextDrawPath(context, kCGPathFill);
          
            CGContextClosePath(context);
/*
            CGRect rect = CGContextGetPathBoundingBox(context);
            CGContextSaveGState(context);
            CGContextClip(context);


            CGFloat locations[2] = { 0.0, 1.0 };
            CGFloat components[8] = { 
                color.red, color.green, color.blue, 1.0,
                color.red * 0.5, color.green * 0.5, color.blue * 0.5, 1.0
            };
            
            CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, 2);
            
            
            CGPoint topCenter = rect.origin;
            CGPoint bottomCenter = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
            
            CGGradientRelease(glossGradient);
            CGColorSpaceRelease(rgbColorspace);
            
            CGContextRestoreGState(context);
*/
            
            // Draw Label
            CGRect squareFrame = CGRectMake(labelX, labelY, 10.0, 10.0);
            CGContextFillRect(context, squareFrame);
            
            [[UIColor blackColor] setFill];

            CGRect labelFrame = CGRectMake(labelX + 15.0, labelY, 200.0, 15.0);
            [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:12.0]];
            
            
            // Set next start point
            startValue = endValue;
            labelY += 20.0;
        }
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
		NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PieChartColorSchemeRGB" ofType:@"plist"];
		NSArray* plistArray = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"Root"];
		colorScheme = [[NSArray alloc] initWithArray:plistArray];
	}
	return colorScheme;
}

/*
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
*/

@end



