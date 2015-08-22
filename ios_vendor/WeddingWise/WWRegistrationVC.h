//
//  WWRegistrationVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWRegistrationVC : UIViewController

@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtName;
@property(nonatomic, weak)IBOutlet UITextField *txtAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtContactNumber;
@property(nonatomic, weak)IBOutlet UIButton *btnVendorType;

@property (nonatomic, weak) IBOutlet UIImageView *imgPickerBG, *imgTextBG;
@property(nonatomic, strong)IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property(nonatomic, strong)NSDictionary *fbResponse;

@property(nonatomic, weak)IBOutlet UIImageView *bgImage;
@property(nonatomic, strong)UIImage *image;

-(IBAction)btnSignUpPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
-(IBAction)btnDonePressed:(id)sender;
@end
