//
//  WWBidListCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/12/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBidListCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *name;
@property(nonatomic, strong)IBOutlet UILabel *inquiryDate;
@property(nonatomic, strong)IBOutlet UILabel *eventDate;
@property(nonatomic, strong)IBOutlet UILabel *details;
@property(nonatomic, strong)IBOutlet UILabel *status;

-(void)setData:(NSDictionary*)data;

@end
