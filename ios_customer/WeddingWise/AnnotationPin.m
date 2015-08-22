//
//  AnnotationPin.m
//  WeddingWise
//
//  Created by Shivam on 7/19/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "AnnotationPin.h"

@implementation AnnotationPin
@synthesize coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    self = [super init];
    coordinate = coord;
    return self;
}
@end
