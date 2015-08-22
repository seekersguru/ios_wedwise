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
    
    [self setTextFieldPlacehoder];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark: IBAction & utility methods:
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor darkGrayColor] withPadding:_txtEmailAddress];
}

-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
}

-(IBAction)btnSignInPressed:(id)sender{
    [_txtEmailAddress resignFirstResponder];
    if([self checkValidations]){
        //Call web service
        NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                     _txtEmailAddress.text,@"email",
                                     @"vendor_forgot_password",@"action",
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

-(IBAction)btnBackPressed:(id)sender{
    [_txtEmailAddress resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_txtEmailAddress resignFirstResponder];
    return YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
