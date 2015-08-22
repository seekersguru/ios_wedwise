//
//  WWScheduleVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWScheduleVC.h"
#import "WWScheduleListingVC.h"

@interface WWScheduleVC ()<UIAlertViewDelegate>

@end

@implementation WWScheduleVC

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [self callWebService:@""];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
   // _scheduleTimeLabel.hidden = YES;
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scheduleVisitAction:(id)sender {
    _scheduleTimeLabel.hidden = NO;
   
    NSDate *selectedDate = [_datePicker date];
    NSDate *selectedTime = [_timePicker date];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:selectedDate];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *time = [dateFormatter stringFromDate:selectedTime];
    
    [self callWebService:[NSString stringWithFormat:@"%@ %@",date,time]];
   
}
-(void)callWebService:(NSString*)time{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppDelegate sharedAppDelegate].vendorEmail,@"vendor_email",
                                 time,@"time",
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"schedule_visit",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"responseDics :%@", responseDics);
         [_scheduleTimeLabel setText:[NSString stringWithFormat:@"Visit scheduled at %@",responseDics[@"json"][@"id"]]];
         
         if(time.length>0){
             [ [WWCommon getSharedObject]createAlertView:kAppName :@"Schedule is created successfully" :self :100];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark UIAlertview delgate methods:
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    WWScheduleListingVC *scheduleVisit=[[WWScheduleListingVC alloc]initWithNibName:@"WWScheduleListingVC" bundle:nil];
    [self.navigationController pushViewController:scheduleVisit animated:YES];
}

@end
