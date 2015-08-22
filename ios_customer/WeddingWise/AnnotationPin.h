//
//  AnnotationPin.h
//  WeddingWise
//
//  Created by Shivam on 7/19/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationPin : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
// add an init method so you can set the coordinate property on startup
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
@end
