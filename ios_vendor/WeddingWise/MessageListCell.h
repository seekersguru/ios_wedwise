//
//  MessageListCell.h
//  WeddingWise
//
//  Created by WeeTech Solution on 08/06/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *subDescLbl;
@end
