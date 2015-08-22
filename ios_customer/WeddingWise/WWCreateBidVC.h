//
//  WWCreateBidVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLCalendarView.h"

@interface WWCreateBidVC : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *headerTitleLabel;
@property (nonatomic, strong) NSString *requestType;    //it will be bid/booking

@property (weak, nonatomic) IBOutlet UITextField *packageTextField;
@property (weak, nonatomic) IBOutlet UITextField *guestTextField;
@property (weak, nonatomic) IBOutlet UITextView *textComment;

@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *eventDateButton;
@property (weak, nonatomic) IBOutlet UILabel *packageDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UILabel *pricingStatic;
@property (weak, nonatomic) IBOutlet UILabel *pricing1;
@property (weak, nonatomic) IBOutlet UILabel *pricing2;

@property (weak, nonatomic) IBOutlet UILabel *checkAvailbility;


@property(nonatomic, weak)IBOutlet UIView *vwCalander;
@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;

//Static Label
@property (weak, nonatomic) IBOutlet UILabel *eventStaticLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeSlotStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageStaticLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;



- (IBAction)bidItAction:(id)sender;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)calendarBackButtonPressed:(id)sender;
- (IBAction)selectClicked:(id)sender;
-(void)rel;

@end
