//
//  WWCategoryDetailVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "YTPlayerView.h"

@interface WWCategoryDetailVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak)IBOutlet UITableView *tblCategoryDetail;
@property(nonatomic, weak)IBOutlet UITableView *tblReadMore;

@property(nonatomic, weak)IBOutlet UIView *packageView;
@property(nonatomic, weak)IBOutlet UIView *mapView;
@property(nonatomic, weak)IBOutlet UIView *descriptionView;
@property(nonatomic, weak)IBOutlet UIView *listingView;
@property(nonatomic, weak)IBOutlet UIView *videoView;
@property(nonatomic, weak)IBOutlet YTPlayerView *playerView;

@property(nonatomic, weak)IBOutlet UIWebView *wbView;
@property(nonatomic, weak)IBOutlet UILabel *webTitle;

@property(nonatomic, weak)IBOutlet UIImageView *ratateImage;
@property(nonatomic, strong)IBOutlet UILabel *lblReadMoreTitle;
@property(nonatomic, strong)IBOutlet UILabel *lblTitle;

@property(nonatomic, strong)NSString *vendorEmail;
@property(nonatomic, strong)NSString *vendorName;

@property(nonatomic, weak)IBOutlet MKMapView *map;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)hideView:(id)sender;

@property(nonatomic, weak)IBOutlet UIButton *inquireButton, *messageButton, *scheduleButton;


@end
