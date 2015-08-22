//
//  WWBookingFooterCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWBookingFooterCell.h"

@implementation WWBookingFooterCell

- (void)awakeFromNib {
    // Initialization code
    _btnAccept.layer.borderWidth = 1;
    _btnAccept.layer.borderColor = [UIColor redColor].CGColor;
    
    _btnPeniding.layer.borderWidth = 1;
    _btnPeniding.layer.borderColor = [UIColor redColor].CGColor;
    
    _btnRebid.layer.borderWidth = 1;
    _btnRebid.layer.borderColor = [UIColor redColor].CGColor;
    
    _btnReject.layer.borderWidth = 1;
    _btnReject.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
