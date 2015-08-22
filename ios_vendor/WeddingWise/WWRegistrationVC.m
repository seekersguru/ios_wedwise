//
//  WWRegistrationVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWRegistrationVC.h"


@interface WWRegistrationVC ()<MBProgressHUDDelegate>
{
    NSArray *_pickerData;
    
}
@property (nonatomic) BOOL isViewPositionOffset;

@end

@implementation WWRegistrationVC

- (void)viewDidLoad {
    
   // [self setTextFieldPlacehoder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    _pickerData=[[NSArray alloc]initWithObjects:
                 @"Banquets",
                 @"Caterers",
                 @"Decoraters",
                 @"Photographers",
                 nil];
    
    [_pickerView setFrame:CGRectMake(0, 700, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [_imgPickerBG setFrame:CGRectMake(0, 700, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
    [_toolBar setFrame:CGRectMake(0, 700, _toolBar.frame.size.width, _toolBar.frame.size.height)];
    
    if(_fbResponse){
        [self fillFaceBookData];
    }
    
    [super viewDidLoad];
}

-(void)fillFaceBookData{
    [_txtEmailAddress setEnabled:NO];
    _txtEmailAddress.text= [_fbResponse valueForKey:@"email"];
    
    [_txtEmailAddress setTextColor:[UIColor lightGrayColor]];
    
    [_txtPassword setHidden:YES];
    //[_btnSkip setHidden:NO];
    
    //Set buttons frame in case FB & G+ login:
    [_btnVendorType setFrame:CGRectMake(_txtPassword.frame.origin.x, _txtPassword.frame.origin.y, _txtPassword.frame.size.width, _txtPassword.frame.size.height)];
    [_txtName setFrame:CGRectMake(_btnVendorType.frame.origin.x, _btnVendorType.frame.origin.y+48, _btnVendorType.frame.size.width, _btnVendorType.frame.size.height)];
    [_txtContactNumber setFrame:CGRectMake(_txtName.frame.origin.x, _txtName.frame.origin.y+48, _txtName.frame.size.width, _txtName.frame.size.height)];
    [_txtAddress setFrame:CGRectMake(_txtContactNumber.frame.origin.x, _txtContactNumber.frame.origin.y+48, _txtContactNumber.frame.size.width, _txtContactNumber.frame.size.height)];
    
    [_imgTextBG setFrame:CGRectMake(_imgTextBG.frame.origin.x, _imgTextBG.frame.origin.y, _imgTextBG.frame.size.width, _imgTextBG.frame.size.height-48)];
}

#pragma mark: IBAction & utility methods:
-(IBAction)showPicker:(id)sender{
    [self showPickerView];
}
-(void)showPickerView{
    [self.view endEditing:YES];
    [self.view addSubview:_pickerView];
    
    [_pickerView setFrame:CGRectMake(0, _pickerView.frame.origin.y, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [_imgPickerBG setFrame:CGRectMake(0, _pickerView.frame.origin.y, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
    [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, _pickerView.frame.origin.y-40, _toolBar.frame.size.width, _toolBar.frame.size.height)];
    
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, self.view.frame.size.height - _pickerView.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         
         [_imgPickerBG setFrame:CGRectMake(0, self.view.frame.size.height - _imgPickerBG.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         
         [_toolBar setFrame:CGRectMake(0, _pickerView.frame.origin.y-40, _toolBar.frame.size.width, _toolBar.frame.size.height)];
     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(IBAction)btnDonePressed:(id)sender{
    [_btnVendorType setTitle:[_pickerData[[_pickerView selectedRowInComponent:0]] capitalizedString] forState:UIControlStateNormal];
    //[_btnVendorType.titleLabel setTextColor:[UIColor blackColor]];
    [_btnVendorType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self hidePickerView];
}
-(void)hidePickerView{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, 700, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         [_imgPickerBG setFrame:CGRectMake(0, 700, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         [_toolBar setFrame:CGRectMake(0, 700, _toolBar.frame.size.width, _toolBar.frame.size.height)];
     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtName resignFirstResponder];
    [_txtAddress resignFirstResponder];
    [_txtContactNumber resignFirstResponder];
    [self hidePickerView];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor darkGrayColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor darkGrayColor] withPadding:_txtPassword];
    [_txtName setTextFieldPlaceholder:@"Name" withcolor:[UIColor darkGrayColor] withPadding:_txtName];
    [_txtContactNumber setTextFieldPlaceholder:@"Contact Number" withcolor:[UIColor darkGrayColor] withPadding:_txtContactNumber];
    [_txtAddress setTextFieldPlaceholder:@"Address" withcolor:[UIColor darkGrayColor] withPadding:_txtAddress];
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
-(void)callRegistrationAPI{
    NSString *password;
    if(_fbResponse){
        password= @"123456";
    }
    else{
        password= _txtPassword.text;
    }
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                 password,@"password",
                                 _txtName.text,@"name",
                                 _txtAddress.text,@"address",
                                 _btnVendorType.titleLabel.text,@"vendor_type",
                                 _txtContactNumber.text,@"contact_number",
                                 @"",@"fbid",
                                 @"",@"gid",
                                 @"vendor_registration",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //Registration successfully
             
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
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter email address." :nil :000 ];
        return NO;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter password." :nil :000 ];
        return NO;
    }
    if (_btnVendorType.titleLabel.text && _btnVendorType.titleLabel.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please select vendor type." :nil :000 ];
        return NO;
    }
    if (_txtName.text && _txtName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter name." :nil :000 ];
        return NO;
    }
    if (_txtContactNumber.text && _txtContactNumber.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter contact number." :nil :000 ];
        return NO;
    }
    if (_txtAddress.text && _txtAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :@"Please enter address." :nil :000 ];
        return NO;
    }
    
    if(_txtEmailAddress.text.length>0){
        if(![[WWCommon getSharedObject] validEmail:_txtEmailAddress.text]){
            
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
        else if (textField== _txtName){
            targetYPosition = _btnVendorType.frame.origin.y;
        }
        else if(textField== _txtContactNumber){
            targetYPosition = _btnVendorType.frame.origin.y;
        }
        else if(textField== _txtAddress){
            targetYPosition = _btnVendorType.frame.origin.y;
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
        [_txtName becomeFirstResponder];
    }
    else if(textField==_txtName){
        [_txtContactNumber becomeFirstResponder];
    }
    else if(textField==_txtContactNumber){
        [_txtAddress becomeFirstResponder];
    }
    else if(textField==_txtAddress){
        [_txtAddress resignFirstResponder];
    }
    return YES;
}
#pragma mark UIPicker view delegate & datasource methods:
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{ NSAttributedString *attString ;
    
    attString = [[NSAttributedString alloc] initWithString:_pickerData[row] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    return attString;
    
}

@end
