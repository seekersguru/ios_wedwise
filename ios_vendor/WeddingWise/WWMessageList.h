//
//  WWMessageList.h
//  WeddingWise
//
//  Created by Dotsquares on 6/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWMessageList : UIViewController
{
    IBOutlet UITableView *messageTable;
    
    IBOutlet UIButton *bidBtn;
    IBOutlet UIButton *bookBtn;
    IBOutlet UIButton *messageBtn;
    IBOutlet NSLayoutConstraint *selectorImageLeadingSpaceConstraint;
    IBOutlet UIImageView *imgSeperator;
    IBOutlet UIButton *btnCreateBid;    
    IBOutlet UIImageView *selectorImage;

}
-(IBAction)createBidPressed:(id)sender;


@end
