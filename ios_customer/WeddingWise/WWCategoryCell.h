//
//  WWCategoryCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WWCategoryCellDelegate <NSObject>

-(void)addFavorites:(id)sender;
@required

@end


@interface WWCategoryCell : UITableViewCell
{
    id <WWCategoryCellDelegate> _favoriteDelegate;
}
@property (nonatomic,strong) id favoriteDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;

@property(nonatomic, weak)IBOutlet UIImageView *imgCategory;
@property(nonatomic, weak)IBOutlet UILabel *lblName;
@property(nonatomic, weak)IBOutlet UILabel *lblVeg;
@property(nonatomic, weak)IBOutlet UILabel *lbl3;
@property(nonatomic, weak)IBOutlet UILabel *lbl4;

@property(nonatomic, weak)IBOutlet UILabel *lblCapacity;
@property(nonatomic, weak)IBOutlet UILabel *lblStartingPrice;

@property(nonatomic, weak)IBOutlet UIImageView *img1;
@property(nonatomic, weak)IBOutlet UIImageView *img2;
@property(nonatomic, weak)IBOutlet UIImageView *img3;
@property(nonatomic, weak)IBOutlet UIImageView *img4;
@property(nonatomic, weak)IBOutlet UIImageView *img5;
@end
