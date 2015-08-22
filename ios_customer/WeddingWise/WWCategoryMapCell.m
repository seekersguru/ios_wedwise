//
//  WWCategoryMapCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryMapCell.h"
#import "AnnotationPin.h"

@interface WWCategoryMapCell ()<MKMapViewDelegate>

@end
@implementation WWCategoryMapCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(IBAction)showFullMapView:(id)sender{
    [self.delegate showMapFullView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showCoordinatesOnMapWithLatitude:(NSString *)latitude longitude:(NSString *)longitude{
    
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.userInteractionEnabled = NO;
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    AnnotationPin *annotation = [[AnnotationPin alloc] initWithCoordinate:coordinates];
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

@end
