//
//  WWChangePasswordVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/23/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWChangePasswordVC.h"
#import "UITextField+ADTextField.h"

@interface WWChangePasswordVC ()

@end

@implementation WWChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [_txtConfirmPassword setTextFieldPlaceholder:@"Confirm password" withcolor:[UIColor darkGrayColor] withPadding:_txtConfirmPassword];
    [_txtNewPassword setTextFieldPlaceholder:@"New password" withcolor:[UIColor darkGrayColor] withPadding:_txtNewPassword];
    [_txtOldPassword setTextFieldPlaceholder:@"Current password" withcolor:[UIColor darkGrayColor] withPadding:_txtOldPassword];
    
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtConfirmPassword withText:_txtConfirmPassword.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtNewPassword withText:_txtNewPassword.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtOldPassword withText:_txtOldPassword.text];
    
    [_lblTitle setFont:[UIFont fontWithName:AppFont size:17.0f]];
}

#pragma mark IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtConfirmPassword resignFirstResponder];
    [_txtNewPassword resignFirstResponder];
    [_txtOldPassword resignFirstResponder];
}
- (IBAction)btnSavePassword:(id)sender{
    NSLog(@"%@",[AppDelegate sharedAppDelegate].userData.identifier);
    if([self checkValidations]){
        NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                     _txtNewPassword.text,@"NewPassword",
                                     _txtOldPassword.text,@"CureentPassword",
                                     [AppDelegate sharedAppDelegate].userData.identifier,@"identifier"
                                     @"ChangePassword",@"action",
                                     nil];
        [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
         {
             //[HUD removeFromSuperview];
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 //Login successfully
                 WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:[responseDics valueForKey:@"json"]];
                 [AppDelegate sharedAppDelegate].userData= userData;
                 
                 //[[AppDelegate sharedAppDelegate]setupViewControllers:self.navigationController];
             }
             
         }
                                                 failure:^(NSString *response)
         {
             DLog(@"%@",response);
         }];
    }
    
}
-(BOOL)checkValidations{
    if (_txtOldPassword.text && _txtOldPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter current password" :nil :000 ];
        return NO   ;
    }
    if (_txtNewPassword.text && _txtNewPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter new password" :nil :000 ];
        return NO;
    }
    if(![_txtNewPassword.text isEqualToString:_txtConfirmPassword.text]){
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Your new password and confirm password does not match." :nil :000 ];
        return NO;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtOldPassword){
        [_txtNewPassword becomeFirstResponder];
    }
    else if(textField==_txtNewPassword){
        [_txtConfirmPassword becomeFirstResponder];
    }
    else if(textField==_txtConfirmPassword){
        [_txtConfirmPassword resignFirstResponder];
    }
    return YES;
}
- (void)toggleAnimation:(UITextField*)textField {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
