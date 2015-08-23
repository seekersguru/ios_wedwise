//
//  WWProfileVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWProfileVC : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgDatePicker;

@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtGroomName;
@property(nonatomic, weak)IBOutlet UITextField *txtBrideName;
@property(nonatomic, weak)IBOutlet UITextField *txtContactNo;
@property(nonatomic, weak)IBOutlet UITextField *txtContactName;
@property(nonatomic, weak)IBOutlet UIButton *btnTentativeDate;
@property(nonatomic, weak)IBOutlet UIButton *btnBackButton;
@property(nonatomic, weak)IBOutlet UIImageView *bgImage;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;
@property(nonatomic, weak)IBOutlet UIButton *btnChangePassword;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

-(IBAction)btnTentativeDatePressed:(id)sender;
-(IBAction)changePassword:(id)sender;
@end
