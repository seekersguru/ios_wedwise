//
//  WWCategoryCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import "WWCategoryCell.h"

@implementation WWCategoryCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)btnFavoriteClicked:(id)sender {
    [_favoriteDelegate addFavorites:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
