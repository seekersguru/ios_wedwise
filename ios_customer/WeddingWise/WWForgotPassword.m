//
//  WWForgotPassword.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/31/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWForgotPassword.h"

@interface WWForgotPassword ()

@end

@implementation WWForgotPassword

- (void)viewDidLoad {
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:lblPolicy withText:lblPolicy.text];
    
    //_bgImage.image= _image;
    [super viewDidLoad];
}
-(IBAction)btnSignInPressed:(id)sender{

    if([self checkValidations]){
        //Call web service
        NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                     _txtEmailAddress.text,@"email",
                                     @"customer_forgot_password",@"action",
                                     nil];
        
        [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
         {
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :responseDics[@"json"][@"message"] :nil :000 ];
             }
         }
                                                 failure:^(NSString *response)
         {
             DLog(@"%@",response);
         }];
    }
    
}
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterEmail :nil :000 ];
        return NO;
    }
    if(_txtEmailAddress.text.length>0){
        if(![[WWCommon getSharedObject] validEmail:_txtEmailAddress.text]){
            [[WWCommon getSharedObject]createAlertView:kAppName :kValidEmail :nil :000 ];
            return NO;
        }
    }
    return YES;
}
-(IBAction)btnBackPressed:(id)sender{
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dismissKeyboard{
    [_txtEmailAddress resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
