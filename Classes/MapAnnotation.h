//
//  MapAnnotation.h
//  FriendsAnalyzer
//
//  Created by Joseph Lin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject  <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString* title;
    
    NSSet* owners;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSSet* owners;

- (NSString*)subtitle;

@end
