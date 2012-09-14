//
//  PieChartView.m
//  FacebookSearch
//
//  Created by Joseph Lin on 2/28/11.
//  Copyright 2011 Joseph Lin. All rights reserved.
//

#import "PieChartView.h"

#define kLabelSquareSize        10.0
#define kLabelSquareSpacing     5.0
#define kLabelFontSize          12.0
#define kLabelRowHeight         15.0



@implementation PieChartView

@synthesize pieChartObjects, colorScheme;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values displayNames:(NSArray*)displayNames
{
    NSInteger keyCount = [keys count];
    
    if ( [values count] != keyCount || [displayNames count] != keyCount )
    {
        NSLog(@"Array counts don't match!");
        return;
    }
    
    self.pieChartObjects = [NSMutableArray arrayWithCapacity:keyCount];
    for ( int i = 0; i < keyCount; i++ )
    {
        id key = keys[i];
        id value = values[i];
        id displayName = displayNames[i];
        PieChartObject* object = [[PieChartObject alloc] initWithKey:key value:value displayName:displayName];
        [pieChartObjects addObject:object];
    }
    

//    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES];
    [pieChartObjects sortUsingComparator:^NSComparisonResult(PieChartObject* obj1, PieChartObject* obj2) {
        if ( [obj1.key intValue] )
        {
            return [obj1.key intValue] > [obj2.key intValue];
        }
        else
        {
            return [obj1.key caseInsensitiveCompare:obj2.key];
        }

    }];
    
    [self setNeedsDisplay];
}

- (void)setPieChartWithKeys:(NSArray*)keys values:(NSArray*)values
{
    [self setPieChartWithKeys:keys values:values displayNames:keys];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (NSArray*)colorScheme
{
	if ( !colorScheme )
	{
		NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"PieChartColorSchemeRGB" ofType:@"plist"];
		NSArray* plistArray = [NSDictionary dictionaryWithContentsOfFile:plistPath][@"Root"];
		colorScheme = [[NSArray alloc] initWithArray:plistArray];
	}
	return colorScheme;
}

- (UIColor*)colorAtIndex:(NSInteger)index
{
    NSInteger colorIndex = index % [self.colorScheme count];
    CGFloat colorFactor = 1 + 0.1 * index / [self.colorScheme count];
    
    NSDictionary* colorDict = (self.colorScheme)[colorIndex];
    CGFloat red = [colorDict[@"red"] floatValue] * colorFactor;
    CGFloat green = [colorDict[@"green"] floatValue] * colorFactor;
    CGFloat blue = [colorDict[@"blue"] floatValue] * colorFactor;
    
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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    [self drawBackground];
    
    //// Set Dimensions ////
    CGFloat radius = ( MIN( rect.size.width , rect.size.height ) / 2 ) * 0.8;
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat centerY = CGRectGetMidY(rect);
    
    
    //// Set Data ////
    NSNumber* valueSum = [pieChartObjects valueForKeyPath:@"@sum.value"];
    NSInteger total = [valueSum intValue];
    CGFloat startValue = 0;
    int index = 0;
    
    CGFloat labelWidth = (self.bounds.size.width - 20) / 6;
    for ( PieChartObject* object in pieChartObjects )
    {
        CGSize size = [object.displayName sizeWithFont:[UIFont systemFontOfSize:kLabelFontSize]];
        if ( size.width + kLabelSquareSize + 4 * kLabelSquareSpacing > labelWidth )
            labelWidth = size.width + kLabelSquareSize + 4 * kLabelSquareSpacing;
    }
    
    for ( PieChartObject* object in pieChartObjects )
    {
        //// Select Color ////
        UIColor* color = [self colorAtIndex:index];
        [color setStroke];
        [color setFill];


        //// Calculate Value ////
        NSInteger value = [object.value intValue];
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
            [object.displayName drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
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
            [object.displayName drawInRect:labelFrame withFont:[UIFont systemFontOfSize:kLabelFontSize]];
        }
        
        
        //// Set next start-point ////
        startValue = endValue;
        index++;
    }
    
}


@end



