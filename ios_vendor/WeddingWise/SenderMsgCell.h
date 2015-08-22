//
//  SenderMsgCell.h
//  WeddingWise
//
//  Created by WeeTech Solution on 08/06/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SenderMsgCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chatMsgTxt;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatMsgTxtWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatMsgTxtHeightConstraint;
@end
