//
//  WWForgotPassword.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/31/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWForgotPassword : UIViewController
{
    IBOutlet UILabel *lblPolicy;
}
@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;

@property(nonatomic, weak)IBOutlet UIImageView *bgImage;
@property(nonatomic, strong)UIImage *image;

-(IBAction)btnSignInPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
@end
