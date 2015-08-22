//
//  WWCategoryDescriptionCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import "WWCategoryDescriptionCell.h"

@implementation WWCategoryDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    //[_btnReadMore.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)readMorePressed:(id)sender{
    [self.delegate showDescriptionReadMoreView];
}
@end
