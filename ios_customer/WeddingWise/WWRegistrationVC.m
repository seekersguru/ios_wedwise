//
//  WWRegistrationVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWRegistrationVC.h"
#import "WWCommon.h"
#import "UITextField+ADTextField.h"

@interface WWRegistrationVC ()<MBProgressHUDDelegate>

@property (nonatomic) BOOL isViewPositionOffset;

@end

@implementation WWRegistrationVC

- (void)viewDidLoad {
    //[self setTextFieldPlacehoder];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:lblPolicy withText:lblPolicy.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnTentativeDate withText:_btnTentativeDate.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnSkip withText:_btnSkip.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnSignIn withText:_btnSignIn.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_btnBack withText:_btnBack.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtEmailAddress withText:_txtEmailAddress.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtPassword withText:_txtPassword.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtGroomName withText:_txtGroomName.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtBrideName withText:_txtBrideName.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtContactNo withText:_txtContactNo.text];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    //_bgImage.image= _image;
    
    [_datePicker setHidden:YES];
     [_imgDatePicker setHidden:YES];
    
    if(_fbResponse){
        [self fillFaceBookData];
    }
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"EmailID"];
    
    if(savedValue.length>0){
        _txtEmailAddress.text= savedValue;
    }
    
    
    //[_btnSkip setHidden:YES];
    
    [super viewDidLoad];
}
-(void)fillFaceBookData{
    [_txtEmailAddress setEnabled:NO];
    _txtEmailAddress.text= [_fbResponse valueForKey:@"email"];
    [_txtEmailAddress setTextColor:[UIColor lightGrayColor]];
    
    [_txtPassword setHidden:YES];
    [_btnSkip setHidden:NO];
    
    //Set buttons frame in case FB & G+ login:
    [_txtBrideName setFrame:CGRectMake(_txtPassword.frame.origin.x, _txtPassword.frame.origin.y, _txtPassword.frame.size.width, _txtPassword.frame.size.height)];
    [_txtGroomName setFrame:CGRectMake(_txtBrideName.frame.origin.x, _txtBrideName.frame.origin.y+48, _txtBrideName.frame.size.width, _txtBrideName.frame.size.height)];
    [_txtContactNo setFrame:CGRectMake(_txtGroomName.frame.origin.x, _txtGroomName.frame.origin.y+48, _txtGroomName.frame.size.width, _txtGroomName.frame.size.height)];
    [_btnTentativeDate setFrame:CGRectMake(_txtContactNo.frame.origin.x, _txtContactNo.frame.origin.y+48, _txtContactNo.frame.size.width, _txtContactNo.frame.size.height)];
    [_imgTextBG setFrame:CGRectMake(_imgTextBG.frame.origin.x, _imgTextBG.frame.origin.y, _imgTextBG.frame.size.width, _imgTextBG.frame.size.height-38)];
    
}
-(void)setTextFieldPlacehoder{
    
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor grayColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor grayColor] withPadding:_txtPassword];
    [_txtGroomName setTextFieldPlaceholder:@"Groom Name" withcolor:[UIColor grayColor] withPadding:_txtGroomName];
    [_txtBrideName setTextFieldPlaceholder:@"Bride Name" withcolor:[UIColor grayColor] withPadding:_txtBrideName];
    [_txtContactNo setTextFieldPlaceholder:@"Contact number" withcolor:[UIColor grayColor] withPadding:_txtContactNo];

}

#pragma mark: IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtGroomName resignFirstResponder];
    [_txtBrideName resignFirstResponder];
    [_txtContactNo resignFirstResponder];
    [_datePicker setHidden:YES];
    [_imgDatePicker setHidden:YES];
}
-(IBAction)btnSignUpPressed:(id)sender{
    [self dismissKeyboard];
    if([self checkValidations]){
        //Call web service
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(callRegistrationAPI) onTarget:self withObject:nil animated:YES];
    }
}
- (IBAction)skipButtonPressed:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:_txtEmailAddress.text forKey:@"EmailID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UITabBarController *tabVC = [[AppDelegate sharedAppDelegate]setupViewControllers:nil];
    [self.navigationController pushViewController:tabVC animated:YES];
}
-(IBAction)btnTentativeDatePressed:(id)sender{
    [_datePicker setHidden:NO];
    [_imgDatePicker setHidden:NO];
    
    //Show only last 100 years dates in picker:
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: +1];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: +1];
    _datePicker.minimumDate = currentDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.date = currentDate;
    
    [_datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
}
-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    [_btnTentativeDate setTitle:str forState:UIControlStateNormal];
}

//yyyy-mm-dd

-(void)callRegistrationAPI{
    
    NSString *password;
    if(_fbResponse){
        password= @"123456";
    }
    else{
        password= _txtPassword.text;
    }
    /*
     [self FBAuthentication:[[NSDictionary alloc] initWithObjectsAndKeys:[GPPSignIn sharedInstance].authentication.userEmail,@"email",person.identifier,@"id",@"google+",@"LoginType", nil]]
     */
    
    NSString *userID =@"";
    if([_userType isEqualToString:@"google+"]){
        userID= _fbResponse[@"id"];
    }
    else if([_userType isEqualToString:@"fbUser"]){
        userID= _fbResponse[@"id"];
    }
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                  password,@"password",
                                 _txtGroomName.text,@"groom_name",
                                 _txtBrideName.text,@"bride_name",
                                 _txtContactNo.text,@"contact_number",
                                 _txtContactName.text,@"contact_name",
                                 _btnTentativeDate.titleLabel.text,@"tentative_wedding_date",
                                 userID,@"fbid",
                                 userID,@"gid",
                                 @"",@"contact_name",
                                 @"",@"operation",
                                 @"",@"identifier",
                                 
                                 @"customer_registration",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSMutableDictionary *requestData = [responseDics[@"request_data"] mutableCopy];
                 [requestData setValue:responseDics[@"json"][@"identifier"] forKey:@"identifier"];
                 
                 [[NSUserDefaults standardUserDefaults] setObject:[responseDics valueForKey:@"json"][@"identifier"] forKey:@"identifier"];
                 [[NSUserDefaults standardUserDefaults] setObject:_txtEmailAddress.text forKey:@"EmailID"];
                 [[NSUserDefaults standardUserDefaults] setObject:_txtPassword.text forKey:@"Password"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:requestData];
                 [AppDelegate sharedAppDelegate].userData= userData;
                 
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterEmail :nil :000 ];
        return NO;
    }
    if(!_fbResponse){
        if (_txtPassword.text && _txtPassword.text.length == 0)
        {
            [[WWCommon getSharedObject]createAlertView:kAppName :kEnterPassword :nil :000 ];
            return NO;
        }
    }
    if (_txtBrideName.text && _txtBrideName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterBrideName :nil :000 ];
        return NO;
    }
    if (_txtGroomName.text && _txtGroomName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kGroomName :nil :000 ];
        return NO;
    }
    if (_txtContactNo.text && _txtContactNo.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterPassword :nil :000 ];
        return NO;
    }
    if (_txtContactName.text && _txtContactName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kValidContactName :nil :000 ];
        return NO;
    }
    
    if (_btnTentativeDate.titleLabel.text && _btnTentativeDate.titleLabel.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kTentativeDate :nil :000 ];
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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (void)toggleAnimation:(UITextField*)textField {
    int keyboardSize = 216;
    int viewHeight = self.view.frame.size.height;
    if(textField.frame.origin.y > (viewHeight - keyboardSize-50)) {
        int targetYPosition=0;
        if (textField == self.txtPassword){
            targetYPosition = _txtEmailAddress.frame.origin.y;
        }
        else if (textField== _txtBrideName){
            targetYPosition = _txtPassword.frame.origin.y;
        }
        else if(textField== _txtGroomName){
            targetYPosition = _txtBrideName.frame.origin.y;
        }
        else if(textField== _txtContactNo){
            targetYPosition = _txtGroomName.frame.origin.y;
        }
        else if(textField== _txtContactName){
            targetYPosition = _txtGroomName.frame.origin.y;
        }
        int diffY = textField.frame.origin.y - targetYPosition;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            if(self.isViewPositionOffset) {
                self.isViewPositionOffset = NO;
                frame.origin.y += diffY;
            } else {
                self.isViewPositionOffset = YES;
                frame.origin.y -= diffY;
            }
            [self.view setFrame:frame];
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtEmailAddress){
        [_txtPassword becomeFirstResponder];
    }
    else if(textField==_txtPassword){
        [_txtBrideName becomeFirstResponder];
    }
    else if(textField==_txtBrideName){
        [_txtGroomName becomeFirstResponder];
    }
    else if(textField==_txtGroomName){
        [_txtContactNo becomeFirstResponder];
    }
    else if(textField==_txtContactNo){
        [_txtContactName becomeFirstResponder];
    }
    else if(textField==_txtContactName){
        [_txtContactName resignFirstResponder];
    }
    return YES;
}
@end
