//
//  WWChangePasswordVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/23/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWChangePasswordVC : UIViewController
@property(nonatomic, weak)IBOutlet UITextField *txtOldPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtNewPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@property(nonatomic, weak)IBOutlet UILabel *lblTitle;
- (IBAction)btnSavePassword:(id)sender;

@end
