//
//  WWCategoryImageCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryImageCell.h"

@implementation WWCategoryImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)showVideoPlayerView:(id)sender{
    [self.delegate showVideoPlayer];
}
-(IBAction)panormaImageButtonClicked:(id)sender{
    [self.delegate show360Image];
}
-(IBAction)btnAddFavoritesPressed:(id)sender{
    [_delegate addFavorites];
}
- (void)showImagesFromArray:(NSArray *)imageLinks{
    _imageArray = imageLinks;
    for (int i = 0; i < imageLinks.count; i++) {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,imageLinks[i]]];
        
        CGRect frame = CGRectMake(i*self.categoryImageScrollView.frame.size.width, 0, self.categoryImageScrollView.frame.size.width, self.categoryImageScrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
        [imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
        [self.categoryImageScrollView addSubview:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
    }
    [self.categoryImageScrollView setPagingEnabled:YES];
    [self.categoryImageScrollView setContentSize:CGSizeMake(imageLinks.count*self.categoryImageScrollView.frame.size.width, 0)];
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture{
//    if ([self.delegate respondsToSelector:@selector(imageSelected:)]) {
//        UIImage *image = [(UIImageView *)gesture.view image];
//        [self.delegate imageSelected:image];
//    }
    if ([self.delegate respondsToSelector:@selector(showImagesOnScroll:)]) {
        [self.delegate showImagesOnScroll:_imageArray];
    }
}
@end
