//
//  WWLoginVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLoginVC.h"
#import "WWRegistrationVC.h"
#import "UITextField+ADTextField.h"
#import "WWCommon.h"
#import "AppDelegate.h"
#import "MyKnotList.h"
#import "WWForgotPassword.h"
#import "AppDelegate.h"

@interface WWLoginVC ()<MBProgressHUDDelegate>

@end
@implementation WWLoginVC

#pragma mark View life cycle methods:
- (void)viewDidLoad {
    //[self setTextFieldPlacehoder];
    
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:lblPolicy withText:lblPolicy.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:btnSignIn withText:btnSignIn.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:btnForgotPassword withText:btnForgotPassword        .titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtEmailAddress withText:_txtEmailAddress.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtPassword withText:_txtPassword.text];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    NSString *savedEmail = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"EmailID"];
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"Password"];
    
    if(savedEmail.length>0){
        _txtEmailAddress.text= savedEmail;
        _txtPassword.text= savedPassword;
        
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor whiteColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor whiteColor] withPadding:_txtPassword];
}
-(IBAction)btnSignInPressed:(id)sender{
  [self dismissKeyboard];
  if([self checkValidations]){
      MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
      [self.view addSubview:HUD];
      
      // Regiser for HUD callbacks so we can remove it from the window at the right time
      HUD.delegate = self;
      
      // Show the HUD while the provided method executes in a new thread
      [HUD showWhileExecuting:@selector(callLoginWebService) onTarget:self withObject:nil animated:YES];
      
  }
    
}
- (void)callLoginWebService {
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                 _txtPassword.text,@"password",
                                 @"customer_login",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //Login successfully
             WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:[responseDics valueForKey:@"json"]];
             [AppDelegate sharedAppDelegate].userData= userData;
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDics valueForKey:@"json"][@"identifier"] forKey:@"identifier"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setObject:_txtEmailAddress.text forKey:@"EmailID"];
             [[NSUserDefaults standardUserDefaults] setObject:_txtPassword.text forKey:@"Password"];
             
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
             [AppDelegate sharedAppDelegate].userData.isProfileComplete= YES;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 UITabBarController *tabVC = [[AppDelegate sharedAppDelegate]setupViewControllers:nil];
                 [self.navigationController pushViewController:tabVC animated:YES];
             });
             
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(IBAction)btnBackPressed:(id)sender{
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterEmail :nil :000 ];
        return NO;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterPassword :nil :000 ];
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (void)toggleAnimation:(UITextField*)textField {
    
    
}
-(IBAction)btnGoogleLoginPressed:(id)sender{
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtEmailAddress){
        [self.txtPassword becomeFirstResponder];
    }
    else if(textField==_txtPassword){
        [_txtPassword resignFirstResponder];
    }
    return YES;
}
-(IBAction)btnForgotPasswordPressed:(id)sender{
    WWForgotPassword *forgotPasowrd=[[WWForgotPassword alloc]initWithNibName:@"WWForgotPassword" bundle:nil];
    //forgotPasowrd.image= _bgImage.image;
    [self.navigationController pushViewController:forgotPasowrd animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
