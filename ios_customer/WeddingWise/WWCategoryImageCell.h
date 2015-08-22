//
//  WWCategoryImageCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageCellDelegate <NSObject>

@required
- (void)showVideoPlayer;
-(void)show360Image;

-(void)addFavorites;


@optional
- (void)imageSelected:(UIImage *)image;
- (void)showImagesOnScroll:(NSArray *)images;
@end

@interface WWCategoryImageCell : UITableViewCell
{
    id <ImageCellDelegate> _delegate;
}
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;

@property (nonatomic, strong) NSArray *imageArray;
@property (weak, nonatomic) IBOutlet UIScrollView *categoryImageScrollView;
@property(nonatomic, weak)IBOutlet UIButton *btnVideoLink;
@property(nonatomic, weak)IBOutlet UIButton *btnImage;
@property(nonatomic, weak)IBOutlet UILabel *lblPrice;
@property (nonatomic,strong) id delegate;

-(IBAction)showVideoPlayerView:(id)sender;
-(IBAction)panormaImageButtonClicked:(id)sender;

- (void)showImagesFromArray:(NSArray *)imageLinks;

-(IBAction)btnAddFavoritesPressed:(id)sender;

@end
