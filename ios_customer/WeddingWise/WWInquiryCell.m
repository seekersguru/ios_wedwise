//
//  WWInquiryCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWInquiryCell.h"

@implementation WWInquiryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDetailData:(NSDictionary*)detailData{
    _lblValue.text=[NSString stringWithFormat:@"%@",[detailData valueForKey:[[detailData allKeys] objectAtIndex:0]]];
    _lblTitle.text=[NSString stringWithFormat:@"%@",[[detailData allKeys] objectAtIndex:0]];
    
    _lblTitle.font = [UIFont fontWithName:AppFont size:11.0];
    _lblValue.font = [UIFont fontWithName:AppFont size:11.0];
}
@end
