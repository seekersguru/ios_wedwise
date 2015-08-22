//
//  WWCategoryCommonCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCategoryCommonCell : UITableViewCell
@property(nonatomic, weak)IBOutlet UILabel *key;
@property(nonatomic, weak)IBOutlet UILabel *value;
@property(nonatomic, weak)IBOutlet UIImageView *imgCheck;

-(void)setCommonData:(NSDictionary*)dicData withIndexPath:(NSIndexPath*)index;

@end
