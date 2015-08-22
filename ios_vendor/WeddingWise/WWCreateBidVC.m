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
    
    BOOL isFlexible;
    BOOL isTimeSlotTextField;
    NIDropDown *dropDown;
    IBOutlet UIButton *btnSelect;
     IBOutlet UIButton *btnPackage;
    UITapGestureRecognizer *tap;
}
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
    
    [self callWebService];
    // Do any additional setup after loading the view from its nib.
}

-(void)callWebService{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 [AppDelegate sharedAppDelegate].vendorEmailID, @"vendor_email",
                                 @"customer_vendor_detail",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             
             WWVendorBookingData *bidInfo = [WWVendorBookingData sharedInstance];
             [bidInfo setVendorBookingInfo:responseDics[@"json"][@"data"][@"book"]];
             
             [_submitButton setTitle:@"Book IT" forState:UIControlStateNormal];
             [_titleView setText:@"Create Book"];
             
             [self performSelector:@selector(setData) withObject:nil afterDelay:3.0 ];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(void)setData{
    [_submitButton setTitle:@"Book IT" forState:UIControlStateNormal];
    [_titleView setText:@"Create Book"];
    
    //set data
    [_packageLabel setText:[WWVendorBookingData sharedInstance].package[@"value"]];
    [_timeSlotTextField setText:[WWVendorBookingData sharedInstance].time_slot[0]];
    
    _pickerArray = [[WWVendorBookingData sharedInstance] time_slot];
    
    if([[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"event_date"]] isEqualToString:@"1"]){
        [_eventStaticLabel setText:@"Event Date"];
    }
    else{
        [_eventStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"event_date"]]];
    }
    
    [_flexibleStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"flexible_date"]]];
    [_timeSlotStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"time_slot"][@"name"]]];
    [_packageStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"package"][@"name"]]];
    [_packageTextField setText:@"Select Package"];
    packageOrder= [[NSMutableArray alloc]initWithArray:[WWVendorBookingData sharedInstance].bookDictionary[@"package"][@"package_order"] ];
    
    NSDictionary *dicPackecList=[WWVendorBookingData sharedInstance].bookDictionary[@"package"][@"package_list"];
    for (NSString *strKey in packageOrder) {
        [packageFinal addObject:[dicPackecList valueForKey:strKey]];
    }
    [_submitButton setTitle:[NSString stringWithFormat:@"%@",[WWVendorBookingData sharedInstance].bookDictionary[@"button"]] forState:UIControlStateNormal];
    _pickerArray = [[WWVendorBookingData sharedInstance] time_slot];
    
    [_bidPriceStaticLabel setHidden:YES];
    [_perPlateStaticLabel setHidden:YES];
    [_minPersonStaticLabel setHidden:YES];
    [_minPersonTextField setHidden:YES];
    [_bidPriceTextField setHidden:YES];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 150)];
    _pickerView.delegate = self;
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    [_timeSlotTextField setInputView:_pickerView];
    [_packageTextField setInputView:_pickerView];
    
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    [doneToolbar setItems:@[item]];
    [_timeSlotTextField setInputAccessoryView:doneToolbar];
    [_packageTextField setInputAccessoryView:doneToolbar];
}


- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidUnload {
    //    [btnSelect release];
    btnSelect = nil;
    [self setBtnSelect:nil];
    [super viewDidUnload];
}
-(void)setLabelFonts{
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_headerTitleLabel withText:_headerTitleLabel.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:12.0 withLabel:_packageLabel withText:_packageLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_timeSlotTextField withText:_timeSlotTextField.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_packageTextField withText:_packageTextField.text];
    
    
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_eventStaticLabel withText:_eventStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_flexibleStaticLabel withText:_flexibleStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_timeSlotStaticLabel withText:_timeSlotStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_packageStaticLabel withText:_packageStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_bidPriceStaticLabel withText:_bidPriceStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_minPersonStaticLabel withText:_minPersonStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:_perPlateStaticLabel withText:_perPlateStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:10.0 withLabel:_bidPriceStaticLabel withText:_bidPriceStaticLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:_titleView withText:_titleView.text];
}
- (void)dismissKeyboard:(id)sender{
    [_timeSlotTextField resignFirstResponder];
    [_packageTextField resignFirstResponder];
}
-(IBAction)btnFlexiblePressed:(id)sender{
    if(isFlexible){
        isFlexible = NO;
        //Selec
        [_btnFlexible setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    }
    else
    {
        isFlexible= YES;
        [_btnFlexible setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
        //
    }
}
-(IBAction)datePickerBtnAction:(id)sender
{
    [tap setCancelsTouchesInView:NO];
    [self showCustomCalendarView];
}
- (void)dismissDatePicker:(id)sender{
    [_datePicker setFrame:CGRectMake(0, 568, self.view.frame.size.width, 150)];
    [doneEventToolbar setFrame:CGRectMake(0, 568, self.view.frame.size.width, 150)];
    [_bidPriceTextField resignFirstResponder];
    [_minPersonTextField resignFirstResponder];
    
}
-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    //_eventDateLabel.text=str;
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
        for (NSDictionary *dicValue in packageFinal) {
            [currentArray addObject:[dicValue valueForKey:@"select_val"]];
        }
        arr = currentArray;
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
        [_packageLabel setText:[packageFinal objectAtIndex:row][@"description"]];
    }
    
    
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

#pragma mark - pickerview delegates/datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return currentArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return currentArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(isTimeSlotTextField)
        [_timeSlotTextField setText:currentArray[row]];
    else{
        [_packageTextField setText:currentArray[row]];
        [_packageLabel setText:[packageFinal objectAtIndex:row][@"description"]];
        
    }
    
}

#pragma mark - textfield delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [currentArray removeAllObjects];
    
    if (textField == _timeSlotTextField){
        [currentArray addObjectsFromArray:_pickerArray];
        isTimeSlotTextField= YES;
    }
    else if(textField == _packageTextField){
        for (NSDictionary *dicValue in packageFinal) {
            [currentArray addObject:[dicValue valueForKey:@"select_val"]];
        }
        isTimeSlotTextField= NO;
    }
    [_pickerView reloadAllComponents];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _timeSlotTextField){
        isTimeSlotTextField= YES;
    }
    else if(textField == _packageTextField) {
        isTimeSlotTextField= NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}
- (void)bidItAction:(id)sender{
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:[WWVendorBookingData sharedInstance].bookDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    @try {
        NSDictionary *requestDict = @{@"identifier" : [[NSUserDefaults standardUserDefaults]
                                                       stringForKey:@"identifier"],
                                      @"receiver_email" : [AppDelegate sharedAppDelegate].vendorEmailID,
                                      @"message" : @"posting bid",
                                      @"from_to" : @"v2c",
                                      @"action" : @"customer_vendor_message_create",
                                      @"mode" : @"mode",
                                      @"device_id" : @"123123",
                                      @"push_data" : @"posting bid",
                                      @"msg_type" : @"book",
                                      @"event_date" : _eventDateButton.titleLabel.text,    //TODO:date should be dynamic, Will do later
                                      @"book_json" : json_string,
                                      @"time_slot" : btnSelect.titleLabel.text,
                                      @"bid_price" : @"",
                                      @"bid_quantity" : @""
                                      };
        
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
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString *failureResponse) {
            
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"exception :%@",[exception description]);
    }
    @finally {
        
    }
    
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
