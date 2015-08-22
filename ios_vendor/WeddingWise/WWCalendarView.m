//
//  WWCalendarView.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/5/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCalendarView.h"
#import "DSLCalendarView.h"
#import "AppDelegate.h"
#import "WWFilterVC.h"     
#import "WWBasicDetails.h"
#import "WWSideMenuVC.h"

@interface WWCalendarView ()<DSLCalendarViewDelegate,FilterProtocolDelegate,UITabBarControllerDelegate,UITabBarDelegate>
{
    NSArray *_pickerData;
    NSDate *lastSelectedDate;
    NSString *filter1,*filter2,*filter3;
    NSString *filter1LabelText,*filter2LabelText,*filter3LabelText;
    NSDate *selectedMonthFromCalendar;
    __weak IBOutlet UILabel *filter1Label;
    __weak IBOutlet UILabel *filter2Label;
    __weak IBOutlet UILabel *filter3Label;
    
}
@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@end

@implementation WWCalendarView
NSUInteger lastSelectedIndex = 0;

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 3) {
        self.tabBarController.selectedIndex = lastSelectedIndex;
        UIViewController *fourthViewController = [[WWSideMenuVC alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:fourthViewController];
        [self presentViewController:navC animated:YES completion:nil];
    }
    else{
        lastSelectedIndex = tabBarController.selectedIndex;
    }
}
- (void)viewDidLoad {
    self.tabBarController.delegate = self;
    [_calendarTitle setFont:[UIFont fontWithName:AppFont size:15.0]];
    _filterView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    
    [[AppDelegate sharedAppDelegate].navigation.navigationBar setHidden:YES];
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    
    
    _pickerData=[[NSArray alloc]initWithObjects:@"January",
                                                @"February",
                                                @"March",
                                                @"April",
                                                @"May",
                                                @"June",
                                                @"July",
                                                @"August",
                                                @"September",
                                                @"October",
                                                @"November",
                                                @"December",
                                                nil];
    [_pickerView setHidden:YES];
    [_toolBar setHidden:YES];
    [_imgPickerBG setHidden:YES];
    
    _calendarView.showEventsOnCalloutView = YES;
    _calendarView.delegate = self;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];;
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:[NSDate date]];
    [[WWBasicDetails sharedInstance] setCurrentDateInCalendar:[NSDate date]];
    [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"identifier"] year:year month:month additionalFilter:@"" completionBlock:^(NSDictionary *response) {
        NSMutableDictionary *eventDict = [NSMutableDictionary new];
        for (NSDictionary *events in [response valueForKey:@"data"]) {
            [eventDict setValue:[NSString stringWithFormat:@"%ld",(long)[[events valueForKey:@"count"] integerValue]] forKey:[NSString stringWithFormat:@"%ld",(long)[[events valueForKey:@"day"] integerValue]]];
        }
        NSDictionary *finalEventDict = @{year:@{month:eventDict}};
        [self showEvents:finalEventDict];
    } errorBlock:^(NSError *error) {
        
    }];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    
    lastSelectedDate = nil;
    [self hideView];
    filter1 = @"";
    filter2 = @"";
    filter3 = @"";
    filter1Label.text = filter1;
    filter2Label.text = filter2;
    filter3Label.text = filter3;
    for (UIButton *bt in _filterView.subviews) {
        if ([bt isKindOfClass:[UIButton class]]) {
            [bt setSelected:NO];
        }
    }
}
- (IBAction)clearAllFilters:(id)sender {
    filter1 = @"";
    filter2 = @"";
    filter3 = @"";
    filter1Label.text = filter1;
    filter2Label.text = filter2;
    filter3Label.text = filter3;
}

- (void)showEvents:(NSDictionary *)eventDict{
    [_calendarView setEventsDictionary:eventDict];
    [_calendarView showCalender];
}
-(void)showPackageReadMoreView{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)filterButtonPressed:(id)sender {
    [self hidePickerView];
    [self showCustomFilterView];
}
-(IBAction)submitButtonPressed:(id)sender{
    filter1Label.text = filter1LabelText;
    filter2Label.text = filter2LabelText;
    filter3Label.text = filter3LabelText;
    [self hideView];
    if (!selectedMonthFromCalendar) {
        selectedMonthFromCalendar = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];;
    [formatter setDateFormat:@"yyyy"];
    NSString *year = [formatter stringFromDate:selectedMonthFromCalendar];
    [formatter setDateFormat:@"MM"];
    NSString *month = [formatter stringFromDate:selectedMonthFromCalendar];
    
    NSString *filterString = @"";
    if (filter1.length > 0 ) {
        filterString = [filterString stringByAppendingString:filter1];
    }
    if (filter2.length > 0) {
        filterString = [filterString stringByAppendingFormat:@"%@%@",filterString.length > 0 ? @"&":@"",filter2];
    }
    if (filter3.length > 0) {
        filterString = [filterString stringByAppendingFormat:@"%@%@",filterString.length > 0 ? @"&":@"",filter3];
    }
    [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"identifier"] year:year month:month additionalFilter:filterString completionBlock:^(NSDictionary *response) {
        NSMutableDictionary *eventDict = [NSMutableDictionary new];
        for (NSDictionary *events in [response valueForKey:@"data"]) {
            [eventDict setValue:[events valueForKey:@"count"] forKey:[events valueForKey:@"day"]];
        }
        NSDictionary *finalEventDict = @{[NSString stringWithFormat:@"%@",year]:@{[NSString stringWithFormat:@"%@",month]:eventDict}};
        [self showEvents:finalEventDict];
    } errorBlock:^(NSError *error) {
        
    }];
}
-(void)showCustomFilterView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _filterView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)hideView{
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _filterView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

}
-(IBAction)showPicker:(id)sender{
    [self hideView];
    [self showPickerView];
}
-(void)showPickerView{
    [self.view endEditing:YES];
    [self.view addSubview:_pickerView];

    [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, self.tabBarController.view.frame.size.height-45, _toolBar.frame.size.width, _toolBar.frame.size.height)];
    
    [_pickerView setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [_imgPickerBG setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];

    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, self.view.frame.size.height - _pickerView.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         
         [_imgPickerBG setFrame:CGRectMake(0, self.view.frame.size.height - _imgPickerBG.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         
         [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, self.tabBarController.view.frame.size.height - _pickerView.frame.size.height-45, _toolBar.frame.size.width, _toolBar.frame.size.height)];
         
         [_pickerView setHidden:NO];
         [_toolBar setHidden:NO];
         [_imgPickerBG setHidden:NO];
     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(IBAction)btnDonePressed:(id)sender{
    [self hidePickerView];
}
-(void)hidePickerView{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         [_imgPickerBG setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         [_pickerView setHidden:YES];
         [_toolBar setHidden:YES];
     }
                     completion:^(BOOL finished){
                         
                     }];
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
    
    attString = [[NSAttributedString alloc] initWithString:[_pickerData[row] uppercaseString] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    return attString;
    
}
#pragma mark: Date range methods:
NSString *selectedDatesString = @"";
-(void)getAllDatesFromRange:(NSString*)startingDate withLastDate:(NSString*)lastDate
{
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [f dateFromString:startingDate];
    NSDate *endDate = [f dateFromString:lastDate];
    
//    NSMutableArray *dates = [@[startDate] mutableCopy];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                          toDate:startDate
                                                         options:0];
        NSString *dateString = [f stringFromDate:date];
        selectedDatesString = [selectedDatesString stringByAppendingFormat:@"%@%@",(selectedDatesString.length == 0)?@"":@",",dateString];
    }
}


#pragma mark - DSLCalendarViewDelegate methods
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        
        NSLog( @"Selected %ld/%ld - %ld/%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.endDay.day, (long)range.endDay.month);
        //store this date to session/singleton instance
        
        NSString *startDate= [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)range.startDay.year,(long)range.startDay.month,(long)range.startDay.day];
        NSString *endDate= [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)range.endDay.year,(long)range.endDay.month,(long)range.endDay.day];
        
        if([startDate isEqualToString:endDate]){
            [[WWBasicDetails sharedInstance] setCalendarDate:[NSString stringWithFormat:@"%02ld-%02ld-%ld",(long)range.startDay.day,(long)range.startDay.month,(long)range.startDay.year]];
            
            if (lastSelectedDate != nil) {
                NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:range.startDay];
                if (lastSelectedDate == date) {
                    self.tabBarController.selectedIndex = 2;
                }
            }
            lastSelectedDate = [[NSCalendar currentCalendar] dateFromComponents:range.startDay];
        }else{
            [self getAllDatesFromRange:startDate withLastDate:endDate];
        }
        
        
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
    selectedMonthFromCalendar = [[NSCalendar currentCalendar] dateFromComponents:month];
    
    [[WWBasicDetails sharedInstance] setCurrentDateInCalendar:selectedMonthFromCalendar];
    [self updateCalendarHomeWithUserId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"identifier"] year:[NSString stringWithFormat:@"%ld",(long)month.year] month:[NSString stringWithFormat:@"%02ld",(long)month.month] additionalFilter:@"" completionBlock:^(NSDictionary *response) {
        NSMutableDictionary *eventDict = [NSMutableDictionary new];
        for (NSDictionary *events in [response valueForKey:@"data"]) {
            [eventDict setValue:[events valueForKey:@"count"] forKey:[events valueForKey:@"day"]];
        }
        NSDictionary *finalEventDict = @{[NSString stringWithFormat:@"%ld",(long)month.year]:@{[NSString stringWithFormat:@"%ld",(long)month.month]:eventDict}};
        [self showEvents:finalEventDict];
    } errorBlock:^(NSError *error) {
        
    }];
    
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

-(IBAction)backButtonPressed:(id)sender{
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.navigation popViewControllerAnimated:YES];
}

- (void)filterDateType:(UIButton *)sender{
    sender.selected = YES;
    if (sender.tag == 6) {
        [(UIButton *)[_filterView viewWithTag:7] setSelected:NO];
        filter3 = @"date=EVENT DATE";
        filter3LabelText = @"EVENT DATE";
    }
    else{
        [(UIButton *)[_filterView viewWithTag:6] setSelected:NO];
        filter3 = @"date=BOOKING DATE";
        filter3LabelText = @"BOOKING DATE";
    }
}

- (void)filterEnquiryType:(UIButton *)sender{
    if (sender.tag == 1) {
        [(UIButton *)[_filterView viewWithTag:2] setSelected:NO];
        filter1 = @"type=ENQUIRY";
        filter1LabelText = @"ENQUIRY";
    }
    else{
        [(UIButton *)[_filterView viewWithTag:1] setSelected:NO];
        filter1 = @"type=BOOKING";
        filter1LabelText = @"BOOKING";
    }
    sender.selected = YES;
}

- (void)filterTimeType:(UIButton *)sender{
    if (sender.tag == 3) {
        [(UIButton *)[_filterView viewWithTag:4] setSelected:NO];
        [(UIButton *)[_filterView viewWithTag:5] setSelected:NO];
        filter2 = @"time=MORNING";
        filter2LabelText = @"MORNING";
    }
    else if (sender.tag == 4){
        [(UIButton *)[_filterView viewWithTag:3] setSelected:NO];
        [(UIButton *)[_filterView viewWithTag:5] setSelected:NO];
        filter2 = @"time=ALL DAY";
        filter2LabelText = @"ALL DAY";
    }
    else{
        [(UIButton *)[_filterView viewWithTag:3] setSelected:NO];
        [(UIButton *)[_filterView viewWithTag:4] setSelected:NO];
        filter2 = @"time=EVENING";
        filter2LabelText = @"EVENING";
    }
    
    sender.selected = YES;
}

-(void)updateCalendarHomeWithUserId:(NSString *)userId year:(NSString *)year month:(NSString *)month additionalFilter:(NSString *)filter completionBlock:(void(^)(NSDictionary *))completion errorBlock:(void(^)(NSError *))error{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 userId,@"identifier",
                                 year,@"year",
                                  month,@"month",
                                 filter,@"filter_string",
                                 @"vendor_calendar_home",@"action",
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
     }failure:^(NSString *response)
     {
         DLog(@"%@",response);
         error([NSError errorWithDomain:@"error" code:0 userInfo:@{NSLocalizedDescriptionKey:response}]);
     }];
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
