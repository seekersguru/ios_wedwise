//
//  WWLoginVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WWLoginVC : UIViewController<UITextFieldDelegate>

@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;


@property(nonatomic, weak)IBOutlet UIImageView *bgImage;

@property(nonatomic, strong)UIImage *image;

-(IBAction)btnSignInPressed:(id)sender;
-(IBAction)btnForgotPasswordPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
@end
