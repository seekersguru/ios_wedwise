//
//  WWForgotPassword.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/31/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWForgotPassword : UIViewController

@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;

-(IBAction)btnSignInPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
@end
