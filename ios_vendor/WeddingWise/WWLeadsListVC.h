//
//  WWLeadsListVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWLeadsListVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *bidBtn;
    IBOutlet UIButton *bookBtn;
    IBOutlet UIImageView *selectorImage;
}
@property (weak, nonatomic) IBOutlet UILabel *lblSortBy;
@property (weak, nonatomic) IBOutlet UIButton *sortInquiryButton;
@property (weak, nonatomic) IBOutlet UIButton *sortEventButton;
@property(nonatomic, weak)IBOutlet UITableView *tblBidView;
@property(nonatomic, weak)IBOutlet UIImageView *imgInquiry, *imgEvent;

@end
