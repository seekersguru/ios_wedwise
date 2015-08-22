//
//  WWInquiryDetailVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWInquiryDetailVC : UIViewController
{
    IBOutlet UITableView *tblInquery;
    IBOutlet UIButton *btnAccept;
    IBOutlet UIButton *btnDecline;
    __weak IBOutlet UILabel *lblStatus;
    __weak IBOutlet UIButton *btnOnHold;
}
@property(nonatomic, strong)NSDictionary *messageData;



-(IBAction)acceptButtonClicked:(id)sender;
-(IBAction)declineButtonClicked:(id)sender;
@end
