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
#import "WWCalendarView.h"
#import "WWForgotPassword.h"
#import "AppDelegate.h"

@interface WWLoginVC ()<MBProgressHUDDelegate>

@end
//Client secret= r4c6Lvxfq99AGauizFsS-Ffw
//Bundle id: com.weddingwise.app



@implementation WWLoginVC


#pragma mark View life cycle methods:
- (void)viewDidLoad {
    [self setTextFieldPlacehoder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController.navigationBar setHidden:YES];
    
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

-(IBAction)btnBackPressed:(id)sender{
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor darkGrayColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor darkGrayColor] withPadding:_txtPassword];
    
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtEmailAddress withText:_txtEmailAddress.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtPassword withText:_txtPassword.text];
}
-(IBAction)btnSignInPressed:(id)sender{
    if([self checkValidations]){
        //Call web service
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
                                 @"vendor_login",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         //[HUD removeFromSuperview];
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //Login successfully
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDics valueForKey:@"json"][@"identifier"] forKey:@"identifier"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:[responseDics valueForKey:@"json"]];
             [AppDelegate sharedAppDelegate].userData= userData;
             [AppDelegate sharedAppDelegate].vendorEmailID= _txtEmailAddress.text;
             
             [[NSUserDefaults standardUserDefaults] setObject:[responseDics valueForKey:@"json"][@"identifier"] forKey:@"identifier"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setObject:_txtEmailAddress.text forKey:@"EmailID"];
             [[NSUserDefaults standardUserDefaults] setObject:_txtPassword.text forKey:@"Password"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             
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
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter email address" :nil :000 ];
        return YES;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter password" :nil :000 ];
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
    [self.navigationController pushViewController:forgotPasowrd animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
