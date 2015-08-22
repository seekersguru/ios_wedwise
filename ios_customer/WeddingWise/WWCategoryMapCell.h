//
//  WWCategoryMapCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@protocol MapCellDelegate <NSObject>

@required
- (void)showMapFullView;

@end

@interface WWCategoryMapCell : UITableViewCell
{
    id <MapCellDelegate> _delegate;
}

@property(nonatomic, weak)IBOutlet MKMapView *mapView;
@property (nonatomic,strong) id delegate;

- (void)showCoordinatesOnMapWithLatitude:(NSString *)latitude longitude:(NSString *)longitude;
@end
