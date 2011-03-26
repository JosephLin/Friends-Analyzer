//
//  PieChartView.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 R/GA. All rights reserved.
//

#import "PieChartView.h"
#import "UIColor-Expanded.h"

#define kLabelSquareSize        10.0
#define kLabelSquareSpacing     5.0
#define kLabelFontSize          12.0
#define kLabelRowHeight         15.0



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

- (void)dealloc
{
	[dict release];
	[colorScheme release];
    [super dealloc];
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

- (NSArray*)sortedKeys
{
    return [[dict allKeys] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
        if ( [obj1 intValue] )
        {
            return [obj1 intValue] > [obj2 intValue];
        }
        else
        {
            return [obj1 caseInsensitiveCompare:obj2];
        }
    }];
}

- (UIColor*)colorAtIndex:(NSInteger)index
{
    NSInteger colorIndex = index % [self.colorScheme count];
    CGFloat colorFactor = 1 + 0.1 * index / [self.colorScheme count];
    
    NSDictionary* colorDict = [self.colorScheme objectAtIndex:colorIndex];
    CGFloat red = [[colorDict objectForKey:@"red"] floatValue] * colorFactor;
    CGFloat green = [[colorDict objectForKey:@"green"] floatValue] * colorFactor;
    CGFloat blue = [[colorDict objectForKey:@"blue"] floatValue] * colorFactor;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}



#pragma mark -
#pragma mark Drawing

- (void)drawBackground
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
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
}

- (void)drawLabels:(NSArray*)values inRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    int index = 0;

    NSArray* sortedKeys = [self sortedKeys];
    NSNumber* maxKeyLength = [sortedKeys valueForKeyPath:@"@max.length"];
    CGFloat labelWidth = [maxKeyLength intValue] * 20.0 + kLabelSquareSize;
    NSInteger labelColCount;
    NSInteger labelRowCount;
    if ( rect.size.width > rect.size.height )
    {
        labelColCount = rect.size.width / labelWidth;
        labelRowCount = ceilf( (float)[sortedKeys count] / labelColCount );
    }
    else
    {
        labelRowCount = rect.size.height / kLabelRowHeight;
        labelColCount = ceilf( (float)[sortedKeys count] / labelRowCount );        
    }
    
    for ( NSString* key in [self sortedKeys] )
    {
        //// Select Color ////
        UIColor* color = [self colorAtIndex:index];
        [color setStroke];
        [color setFill];
        index++;
        
        //// Draw Label ////
        if ( rect.size.width > rect.size.height )     // Portrait; draw labels at the bottom.
        {
            CGFloat labelX = index % labelColCount * labelWidth;
            CGFloat labelY = index / labelColCount * kLabelRowHeight;
            CGRect squareFrame = CGRectMake(labelX, labelY, kLabelSquareSize, kLabelSquareSize);
            CGContextFillRect(context, squareFrame);
            
            [[UIColor blackColor] setFill];
            CGRect labelFrame = CGRectMake(labelX + kLabelSquareSize + kLabelSquareSpacing, labelY, labelWidth, kLabelRowHeight);
            [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
        }
        else                                                        // Landscapel draw labels at the left side.
        {
            //            CGRect squareFrame = CGRectMake(labelX, labelY, kLabelSquareSize, kLabelSquareSize);
            //            CGContextFillRect(context, squareFrame);
            //            
            //            [[UIColor blackColor] setFill];
            //            CGRect labelFrame = CGRectMake(labelX + kLabelSquareSize + kLabelSquareSpacing, labelY, 200.0, kLabelRowHeight);
            //            [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    [self drawBackground];
    
    //// Set Dimensions ////
    CGFloat radius = ( MIN( rect.size.width , rect.size.height ) / 2 ) * 0.8;
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    
    
    //// Set Data ////
    NSNumber* valueSum = [[dict allValues] valueForKeyPath:@"@sum.intValue"];
    NSInteger total = [valueSum intValue];
    CGFloat startValue = 0;
    int index = 0;
    
    NSArray* sortedKeys = [self sortedKeys];
    
    //    NSNumber* maxKeyLength = [sortedKeys valueForKeyPath:@"@max.length"];
    //    CGFloat labelWidth = [maxKeyLength intValue] * 20.0 + kLabelSquareSize;
    CGFloat labelWidth = (self.bounds.size.width - 20) / 6;
    for ( NSString* key in sortedKeys )
    {
        CGSize size = [key sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
        if ( size.width + kLabelSquareSize + 4 * kLabelSquareSpacing > labelWidth )
            labelWidth = size.width + kLabelSquareSize + 4 * kLabelSquareSpacing;
    }
    
    for ( NSString* key in sortedKeys )
    {
        //// Select Color ////
        UIColor* color = [self colorAtIndex:index];
        [color setStroke];
        [color setFill];


        //// Calculate Value ////
        NSInteger value = [[dict objectForKey:key] intValue];
        CGFloat endValue = startValue + value;
        CGFloat startAngle = 2 * M_PI * startValue / total;
        CGFloat endAngle = 2 * M_PI * endValue / total;
        
        
        //// Draw pie ////
        CGContextAddArc(context, centerX, centerY, radius, startAngle - M_PI_2, endAngle - M_PI_2, NO);
        CGContextAddLineToPoint(context, centerX, centerY);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFill);

        
        //// Draw Label ////
        if ( self.bounds.size.height > self.bounds.size.width )     // Portrait; draw labels at the bottom.
        {
            CGRect labelRect = CGRectMake( 0, 0, self.bounds.size.width, (self.bounds.size.height - self.bounds.size.width) / 2 );
            CGRect labelRectInset = CGRectInset(labelRect, 10, 10);

            NSInteger labelColCount = labelRectInset.size.width / labelWidth;
            CGFloat labelX = index % labelColCount * labelWidth + labelRectInset.origin.x;
            CGFloat labelY = index / labelColCount * kLabelRowHeight + labelRectInset.origin.y;
            CGRect squareFrame = CGRectMake(labelX, labelY, kLabelSquareSize, kLabelSquareSize);
            CGContextFillRect(context, squareFrame);
            
            [[UIColor blackColor] setFill];
            CGRect labelFrame = CGRectMake(labelX + kLabelSquareSize + kLabelSquareSpacing, labelY, labelWidth, kLabelRowHeight);
            [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
        }
        else                                                        // Landscapel draw labels at the left side.
        {
            CGRect labelRect = CGRectMake( 0, 0, (self.bounds.size.width - self.bounds.size.height) / 2, self.bounds.size.height );
            CGRect labelRectInset = CGRectInset(labelRect, 10, 10);
            
            NSInteger labelRowCount = labelRectInset.size.height / kLabelRowHeight;
            CGFloat labelX = index / labelRowCount * labelWidth + labelRectInset.origin.x;
            CGFloat labelY = index % labelRowCount * kLabelRowHeight + labelRectInset.origin.y;
            CGRect squareFrame = CGRectMake(labelX, labelY, kLabelSquareSize, kLabelSquareSize);
            CGContextFillRect(context, squareFrame);
            
            [[UIColor blackColor] setFill];
            CGRect labelFrame = CGRectMake(labelX + kLabelSquareSize + kLabelSquareSpacing, labelY, labelWidth, kLabelRowHeight);
            [key drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
        }
        
        
        //// Set next start-point ////
        startValue = endValue;
        index++;
    }
    
}


@end



