//
//  WWAvailabilityVC.m
//  WedWise Vendor
//
//  Created by Shiv Vaishnav on 7/29/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWAvailabilityVC.h"
#import "DSLCalendarView.h"
#import "WWBasicDetails.h"
#import "AppDelegate.h"

@interface WWAvailabilityVC ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,DSLCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet DSLCalendarView *calendar;
@property (weak, nonatomic) IBOutlet UITextField *timeSlotTextfield;
@property (nonatomic, strong) NSArray *timeSlotArray;
@property (nonatomic, strong) NSArray *availabilityArray;
@property (nonatomic, strong) NSString *selectedDatesString;
@property (weak, nonatomic) IBOutlet UITextField *availabilityTextfield;
@property (nonatomic, strong) NSString *time_slot;
@property (nonatomic, strong) NSString *availability;

@end

@implementation WWAvailabilityVC
{
    NSString *strAvailability;
}
- (UIPickerView *)pickerView{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 164)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    return pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _time_slot= @"";
    _availability = @"";
    
    [_timeSlotTextfield setInputView:[self pickerView]];
    [_availabilityTextfield setInputView:[self pickerView]];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolbar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTimeSlotPicking:)];
    [toolbar setItems:@[doneButton]];
    [_timeSlotTextfield setInputAccessoryView:toolbar];
    [_availabilityTextfield setInputAccessoryView:toolbar];
    
    strAvailability=@"";
    
    _timeSlotArray = @[@"Morning",@"Evening",@"All Day"];
    _availabilityArray = @[@"Availability",@"Ongoing Enquiry", @"Booking"];
    _calendar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
//    NSDate *currentMonth = [[WWBasicDetails sharedInstance] currentDateInCalendar];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy"];
//    NSString *year = [df stringFromDate:currentMonth];
//    [df setDateFormat:@"MM"];
    NSString *year = [NSString stringWithFormat:@"%ld",(long)_calendar.visibleMonth.year];
    NSString *month = [NSString stringWithFormat:@"%02ld",(long)_calendar.visibleMonth.month];
    
    
    [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"identifier"] year:year month:month additionalFilter:@"" availityType:_availability timeSlot:_time_slot completionBlock:^(NSDictionary *response) {
        NSMutableDictionary *eventDict = [NSMutableDictionary new];
        for (NSDictionary *events in [response valueForKey:@"data"]) {
            [eventDict setValue:[events valueForKey:@"img"] forKey:[events valueForKey:@"day"]];
        }
        NSDictionary *finalEventDict = @{[year stringByReplacingOccurrencesOfString:@" " withString:@""]:@{[month stringByReplacingOccurrencesOfString:@" " withString:@""]:eventDict}};
//        NSDictionary *finalEventDict = @{year:@{month:eventDict}};
        [self showAvailability:finalEventDict];

    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark - custom actions
- (void)showAvailability:(NSDictionary *)dict{
    [_calendar setAvailabilityDict:dict];
    [_calendar showCalender];
}
- (void)doneTimeSlotPicking:(id)sender{
    [_timeSlotTextfield resignFirstResponder];
    [_availabilityTextfield resignFirstResponder];
}
- (IBAction)setAvailabilityAction:(id)sender {
    if (_selectedDatesString == nil || _selectedDatesString.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select dates." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if (_availabilityTextfield.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select availability." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else if (_timeSlotTextfield.text.length == 0){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select time slot." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
    else{
        //call api to add availability
        // then refresh the view
        NSString *year;
        NSString *month;
        if (!dateConponent) {
            year = [NSString stringWithFormat:@"%ld",(long)_calendar.visibleMonth.year];
            month = [NSString stringWithFormat:@"%02ld",(long)_calendar.visibleMonth.month];
        }
        else{
            year = [NSString stringWithFormat:@"%ld",(long)dateConponent.year];
            month = [NSString stringWithFormat:@"%02ld",(long)dateConponent.month];
        }
        
    
//        if([_availability isEqualToString:@"availability"]){
//            strAvailability= @"available";
//        }
//        else if([_availability isEqualToString:@"booking"]){
//            strAvailability =@"booked";
//        }
//        else{
//            strAvailability= _availability;
//        }
        
        year = [year stringByReplacingOccurrencesOfString:@" " withString:@""];
        month = [month stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"identifier"] year:year month:month additionalFilter:_selectedDatesString availityType:_availability timeSlot:_time_slot completionBlock:^(NSDictionary *response) {
            NSMutableDictionary *eventDict = [NSMutableDictionary new];
            for (NSDictionary *events in [response valueForKey:@"data"]) {
                [eventDict setValue:[events valueForKey:@"img"] forKey:[events valueForKey:@"day"]];
            }
            NSDictionary *finalEventDict = @{year:@{month:eventDict}};
            [self showAvailability:finalEventDict];
            
        } errorBlock:^(NSError *error) {
            
        }];
    }
}
#pragma mark - textfield delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.text.length==0)
        [(UIPickerView *)[textField inputView] selectRow:0 inComponent:0 animated:YES];
    
    
    if (textField == _timeSlotTextfield || textField == _availabilityTextfield) {
        [(UIPickerView *)[textField inputView] reloadAllComponents];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.text.length==0){
        if(textField==_availabilityTextfield){
            _availabilityTextfield.text = _availabilityArray[0];
        }
        else if(textField==_timeSlotTextfield){
            _timeSlotTextfield.text = _timeSlotArray[0];
        }
    }
    
}
#pragma mark - pickerview delegate and datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([_availabilityTextfield isFirstResponder]) {
        return _availabilityArray.count;
    }
    return _timeSlotArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([_availabilityTextfield isFirstResponder]) {
        return _availabilityArray[row];
    }
    return _timeSlotArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([_availabilityTextfield isFirstResponder]) {
        _availabilityTextfield.text = _availabilityArray[row];
    }
    else{
        _timeSlotTextfield.text = _timeSlotArray[row];
    }
    
    if ([_timeSlotTextfield isFirstResponder]) {
        switch (row) {
            case 0:
                _time_slot = @"morning";
                break;
            case 1:
                _time_slot = @"evening";
                break;
            case 2:
                _time_slot = @"all_day";
                break;
            default:
                break;
        }
    }
    else{
        switch (row) {
            case 0:
                _availability = @"available";
                break;
            case 1:
                _availability = @"ongoing_enquiry";
                break;
            case 2:
                _availability = @"booked";
                break;
            default:
                break;
        }
    }
}

#pragma mark - calendar delegate
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %ld/%ld - %ld/%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.endDay.day, (long)range.endDay.month);
        //store this date to session/singleton instance
        
        NSString *startDate= [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)range.startDay.year,(long)range.startDay.month,(long)range.startDay.day];
        NSString *endDate= [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)range.endDay.year,(long)range.endDay.month,(long)range.endDay.day];
        
       // if([startDate isEqualToString:endDate]){
            //[self getAllDatesFromRange:startDate withLastDate:endDate];
        //}else{
            [self getAllDatesFromRange:startDate withLastDate:endDate];
        //}
        
        
    }
    else {
        NSLog( @"No selection" );
    }
}
-(void)getAllDatesFromRange:(NSString*)startingDate withLastDate:(NSString*)lastDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:startingDate];
    NSDate *endDate = [f dateFromString:lastDate];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    _selectedDatesString = [[NSString alloc] init];
    
    for (int i = 0; i < components.day+1; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                          toDate:startDate
                                                         options:0];
        NSString *dateString = [f stringFromDate:date];
        _selectedDatesString = [_selectedDatesString stringByAppendingFormat:@"%@%@",(_selectedDatesString.length == 0)?@"":@",",dateString];
    }
}
NSDateComponents *dateConponent = nil;
- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    dateConponent = month;
    _selectedDatesString = @"";
    _availabilityTextfield.text = @"";
    _timeSlotTextfield.text = @"";
    [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"identifier"] year:[NSString stringWithFormat:@"%ld",(long)month.year] month:[NSString stringWithFormat:@"%02ld",(long)month.month] additionalFilter:@"" availityType:@"" timeSlot:@"" completionBlock:^(NSDictionary *response) {
        
                NSMutableDictionary *eventDict = [NSMutableDictionary new];
                for (NSDictionary *events in [response valueForKey:@"data"]) {
                    [eventDict setValue:[events valueForKey:@"img"] forKey:[events valueForKey:@"day"]];
                }
                NSDictionary *finalEventDict = @{[[NSString stringWithFormat:@"%ld",(long)month.year] stringByReplacingOccurrencesOfString:@" " withString:@""]:@{[[NSString stringWithFormat:@"%ld",(long)month.month] stringByReplacingOccurrencesOfString:@" " withString:@""]:eventDict}};
                [self showAvailability:finalEventDict];

        
    } errorBlock:^(NSError *error) {
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateCalendarHomeWithUserId:(NSString *)userId year:(NSString *)year month:(NSString *)month additionalFilter:(NSString *)filter availityType:(NSString *)availityType timeSlot:(NSString *)timeSlot completionBlock:(void(^)(NSDictionary *))completion errorBlock:(void(^)(NSError *))error{
    
//    [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@"processing"];
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 userId,@"identifier",
                                 year?year:@"",@"year",
                                 month?month:@"",@"month",
                                 filter?filter:@"",@"dates",
                                 timeSlot?timeSlot:@"",@"time_slot",
                                 availityType?availityType:@"",@"avail_type",
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 @"vendor_calendar_availability",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             error([NSError errorWithDomain:@"error" code:0 userInfo:[responseDics valueForKey:@"message"]]);
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             completion([responseDics valueForKey:@"json"]);
         }
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }failure:^(NSString *response)
     {
         DLog(@"%@",response);
         error([NSError errorWithDomain:@"error" code:0 userInfo:@{NSLocalizedDescriptionKey:response}]);
     }];
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
