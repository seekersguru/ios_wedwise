//
//  WWBidListCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/12/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWBidListCell.h"

@implementation WWBidListCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setData:(NSDictionary*)data
{
    _name.text= [data valueForKey:@"receiver_name"];
    _inquiryDate.text= [data valueForKey:@"event_date"];
    _eventDate.text= [[data valueForKey:@"msg_time"] substringToIndex:[[data valueForKey:@"msg_time"] length] - 9];
    
    _details.text= [NSString stringWithFormat:@"%@ \n %@",[data valueForKey:@"line1"],[data valueForKey:@"line2"] ];
    _status.text=[data valueForKey:@"status"];
    _time.text= [data valueForKey:@"msg_time_only"];
    
    _name.font = [UIFont fontWithName:AppFont size:14.0];
    _inquiryDate.font = [UIFont fontWithName:AppFont size:12.0];
    _eventDate.font = [UIFont fontWithName:AppFont size:12.0];
    _details.font = [UIFont fontWithName:AppFont size:12.0];
    _status.font = [UIFont fontWithName:AppFont size:12.0];
    _time.font = [UIFont fontWithName:AppFont size:10.0];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
