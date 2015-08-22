//
//  WWInquiryCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWInquiryCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UILabel *lblTitle;
@property(nonatomic, weak)IBOutlet UILabel *lblValue;

-(void)setDetailData:(NSDictionary*)detailData;

@end
