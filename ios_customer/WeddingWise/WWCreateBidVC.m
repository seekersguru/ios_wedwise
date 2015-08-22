//
//  WWCreateBidVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCreateBidVC.h"
#import "WWVendorDetailData.h"
#import "WWWebService.h"
#import "NIDropDown.h"
#import "DSLCalendarView.h"

@interface WWCreateBidVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate, NIDropDownDelegate,DSLCalendarViewDelegate, UIAlertViewDelegate>

{
    NSMutableArray *packageList;
    NSMutableArray *packageOrder;
    NSMutableArray *currentArray;
    NSMutableArray *packageFinal;
    UIToolbar *doneEventToolbar;
    BOOL isTimeSlotTextField;
    NIDropDown *dropDown;
    IBOutlet UIButton *btnSelect;
     IBOutlet UIButton *btnPackage;
    UITapGestureRecognizer *tap;
    
    NSString *timeSlotID;
    NSString *packegeID;
    
}
@property(nonatomic, assign)BOOL isViewPositionOffset;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@end

@implementation WWCreateBidVC
@synthesize btnSelect;

- (void)viewDidLoad {
    [super viewDidLoad];
    currentArray =[NSMutableArray new];
    packageFinal =[NSMutableArray new];
    
    packegeID = @"";
    timeSlotID = @"";
    
    btnSelect.layer.borderWidth = 1;
    btnSelect.layer.borderColor = [[UIColor blackColor] CGColor];
    btnSelect.layer.cornerRadius = 5;
    
    btnPackage.layer.borderWidth = 1;
    btnPackage.layer.borderColor = [[UIColor blackColor] CGColor];
    btnPackage.layer.cornerRadius = 5;
    
    [self.navigationController.navigationBar setHidden:YES];
    
     tap= [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissDatePicker:)];
    [self.view addGestureRecognizer:tap];
    
    
    _calendarView.showEventsOnCalloutView = YES;
    _calendarView.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    if (_requestType.length == 0) {
        _requestType = @"bid";
        [_titleView setText:@"Create Bid"];
        //TODO:if not come from messagelist then directly assigning it to bid for now
        //it will depend on tab bar icons
    }
    BOOL hideFields = NO;
    if ([_requestType isEqualToString:@"book"]) {
        
        
    }
    else{
        
        [_packageDescriptionLabel setText:[WWVendorBidData sharedInstance].package[@"value"]];
        
    
        if([[WWVendorBidData sharedInstance].bidDictionary[@"event_date"] isEqualToString:@"1"]){
            [_eventStaticLabel setText:@"Event Date"];
        }
        else
            [_eventStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"event_date"]]];
        
        [_timeSlotStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"time_slot"][@"name"]]];
        [_packageStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"package"][@"name"]]];
        [_packageTextField setText:@"Select Package"];
         packageOrder= [[NSMutableArray alloc]initWithArray:[WWVendorBidData sharedInstance].bidDictionary[@"package"][@"package_order"] ];

        [_submitButton setTitle:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"button"]] forState:UIControlStateNormal];
        
        packageFinal= [[NSMutableArray alloc]init];
        _pickerArray = [[WWVendorBidData sharedInstance] time_slot];
        packageFinal=[WWVendorBidData sharedInstance].packageIOS;
    }
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 150)];
    _pickerView.delegate = self;
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    
    [_packageTextField setInputView:_pickerView];
    
    [self setLabelFonts];
}
- (void)viewDidUnload {
    //    [btnSelect release];
    btnSelect = nil;
    [self setBtnSelect:nil];
    [super viewDidUnload];
}
-(void)setLabelFonts{
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_headerTitleLabel withText:_headerTitleLabel.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:12.0 withLabel:_packageDescriptionLabel withText:_packageDescriptionLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_packageTextField withText:_packageTextField.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_eventStaticLabel withText:_eventStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_timeSlotStaticLabel withText:_timeSlotStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_packageStaticLabel withText:_packageStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:_titleView withText:_titleView.text];
    
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:_pricing1 withText:_pricing1.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:_pricing2 withText:_pricing2.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:_titleView withText:_titleView.text];
}
- (void)dismissKeyboard:(id)sender{
    
}

-(IBAction)datePickerBtnAction:(id)sender
{
    [tap setCancelsTouchesInView:NO];
    [self showCustomCalendarView];
}
- (void)dismissDatePicker:(id)sender{
    [_guestTextField resignFirstResponder];
    [_textComment resignFirstResponder];
}
-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    [_eventDateButton setTitle:str forState:UIControlStateNormal];
}

- (IBAction)selectClicked:(id)sender {
    NSArray * arr = [[NSArray alloc] init];
    UIButton *btn= sender;
    [currentArray removeAllObjects];
    [tap setCancelsTouchesInView:NO];
    
    if(btn.tag==1){
        arr = _pickerArray;
    }
    else if (btn.tag==2){
        arr = packageFinal;
    }    
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender withRow:(NSInteger)row withButtonTag:(NSInteger)buttonTag{
    [self rel];
    if(buttonTag==2){
        [_packageDescriptionLabel setText:[[WWVendorBidData sharedInstance] package][@"package_list"][[[packageFinal objectAtIndex:row] objectAtIndex:0]][@"description"]];
        [_pricing1 setText:[[WWVendorBidData sharedInstance] package][@"package_list"][[[packageFinal objectAtIndex:row] objectAtIndex:0]][@"pricing"][@"line1"]];
        [_pricing2 setText:[[WWVendorBidData sharedInstance] package][@"package_list"][[[packageFinal objectAtIndex:row] objectAtIndex:0]][@"pricing"][@"line2"]];
        
        packegeID= [[_pickerArray objectAtIndex:row] objectAtIndex:0];
    }
    if(buttonTag==1){
        
        timeSlotID=[[_pickerArray objectAtIndex:row] objectAtIndex:0];
        if(![_eventDateButton.titleLabel.text isEqualToString:@"Select Date"]){
            [self callAvailabilityAPI:row];
        }
    }
}
-(void)niSelectValue:(id)sender{

}
-(void)rel{
    dropDown = nil;
    [tap setCancelsTouchesInView:YES];
}
#pragma mark CalendarView
-(void)showCustomCalendarView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vwCalander.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60);
                         //[_vwCalander setBackgroundColor:[UIColor whiteColor]];
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)callAvailabilityAPI:(NSInteger)row{
    
    if(_eventDateButton.titleLabel.text && btnSelect.titleLabel.text){
        NSDictionary *reqParameters= [[NSDictionary alloc]initWithObjectsAndKeys:
                                      @"check_availability",@"action",
                                      [[NSUserDefaults standardUserDefaults]
                                       stringForKey:@"identifier"],@"identifier",
                                      [AppDelegate sharedAppDelegate].vendorEmail, @"vendor_email",
                                      [[_pickerArray objectAtIndex:row] objectAtIndex:0],@"time_slot",
                                      _eventDateButton.titleLabel.text,@"event_date",
                                      nil];
        
        [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
         {
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 if([[NSString stringWithFormat:@"%@",responseDics[@"json"][@"available"]] isEqualToString:@"1"]){
                     [_checkAvailbility setText:@"Available"];
                     [_checkAvailbility setTextColor:[UIColor greenColor]];
                 }
                 else{
                     [_checkAvailbility setText:@"Unavailable"];
                     [_checkAvailbility setTextColor:[UIColor redColor]];
                 }
                 [_checkAvailbility setFont:[UIFont fontWithName:AppFont size:15.0f]];
             }
             
         }
                                                 failure:^(NSString *response)
         {
             DLog(@"%@",response);
         }];
    }
}


#pragma mark - textfield delegate methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Comments"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [self toggleAnimation:nil withTextView:textView];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
        textView.textColor = [UIColor lightGrayColor];
    }
    [self toggleAnimation:nil withTextView:textView];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self toggleAnimation:textField withTextView:nil];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_guestTextField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField withTextView:nil];
}
- (void)toggleAnimation:(UITextField*)textField withTextView:(UITextView*)textView {
    int keyboardSize = 216;
    int viewHeight = self.view.frame.size.height;
   
    if(textField.frame.origin.y > (viewHeight - keyboardSize-50) || textView.frame.origin.y > (viewHeight - keyboardSize-50)) {
        int targetYPosition=0;
        if (textField == self.guestTextField || textView == self.textComment){
            targetYPosition = _packageDescriptionLabel.frame.origin.y;
        }
        
        int diffY;
        if(textView){
            diffY = textView.frame.origin.y - targetYPosition;
        }
        else{
            diffY = textField.frame.origin.y - targetYPosition;
        }
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
- (void)bidItAction:(id)sender{
    NSString *json_string = nil;
    
    NSString *messageType;
    NSString *jsonType;
    
    if ([_requestType isEqualToString:@"bid"]) {
        //check validations for bid price
        NSString *errorMessage = nil;
        if (errorMessage) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:[WWVendorBidData sharedInstance].bidDictionary options:NSJSONWritingPrettyPrinted error:nil];
        json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        messageType= @"bid";
        jsonType= @"bid_json";
    }
    else{
        NSData *data = [NSJSONSerialization dataWithJSONObject:[WWVendorBookingData sharedInstance].bookDictionary options:NSJSONWritingPrettyPrinted error:nil];
        json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
         messageType= @"book";
        jsonType= @"book_json";
    }
    
    NSDictionary *requestDict = @{@"identifier" : [[NSUserDefaults standardUserDefaults]
                                                   stringForKey:@"identifier"],
                                  @"receiver_email" : [WWVendorDetailData sharedInstance].vendorEmail,
                                  @"message" : @"IOS creating bid",
                                  @"from_to" : @"c2v",
                                  @"action" : @"customer_vendor_message_create",
                                  @"mode" : @"ios",
                                  @"device_id" : @"123123",
                                  @"push_data" : @"posting bid",
                                  @"msg_type" : messageType,
                                  @"event_date" : _eventDateButton.titleLabel.text,    //TODO:date should be dynamic, Will do later
                                  jsonType : json_string,
                                  @"time_slot" :timeSlotID,
                                  @"package":packegeID, //TODO:make dynamic
                                  @"num_guests":_guestTextField.text,
                                  @"notes":_textComment.text,
                                  };
    //[[_pickerArray objectAtIndex:1] objectAtIndex:0]
    //[[packageFinal objectAtIndex:1] objectAtIndex:0]
    
    [[WWWebService sharedInstanceAPI] callWebService:requestDict imgData:nil loadThreadWithCompletion:^(NSDictionary *response) {
        if([[response valueForKey:@"result"] isEqualToString:@"error"]){
            [[WWCommon getSharedObject]createAlertView:kAppName :[response valueForKey:@"message"] :nil :000 ];
        }
        else if ([[response valueForKey:@"result"] isEqualToString:@"success"]){
            NSString *successMsg = nil;
            if ([_requestType isEqualToString:@"bid"]) {
                successMsg = @"Bid successfully created";
            }
            else{
                successMsg = @"Booking successfully created";
            }
            [[WWCommon getSharedObject]createAlertView:@"" :successMsg :self :000 ];
            //go back to vendor detail page
            self.tabBarController.selectedIndex = 0;
        }
    } failure:^(NSString *failureResponse) {
        
    }];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)calendarBackButtonPressed:(id)sender{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vwCalander.frame = CGRectMake(0, 700, self.view.frame.size.width, self.view.frame.size.height-60);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
#pragma mark - DSLCalendarViewDelegate methods
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %ld/%ld/%ld - %ld/%ld/%ld", (long)range.startDay.day, (long)range.startDay.month,(long)range.startDay.year, (long)range.endDay.day, (long)range.endDay.month, (long)range.endDay.year);
        //store this date to session/singleton instance
        
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        dateFormat.dateStyle=NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *selecteDate= [dateFormat dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)range.startDay.year, (long)range.startDay.month,(long)range.startDay.day]];
    
        NSString *strDate=[dateFormat stringFromDate:selecteDate];
        
        [_eventDateButton setTitle:strDate forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _vwCalander.frame = CGRectMake(0, 700, self.view.frame.size.width, self.view.frame.size.height-60);
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}
#pragma mark UIalertview delegate methods:
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
