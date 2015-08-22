//
//  WWCalendarView.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/5/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCalendarView : UIViewController

@property(nonatomic, strong)IBOutlet UIToolbar *toolBar;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIImageView *imgPickerBG;
@property(nonatomic, weak)IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UILabel *calendarTitle;

-(IBAction)btnDonePressed:(id)sender;
-(IBAction)submitButtonPressed:(id)sender;
- (IBAction)filterDateType:(UIButton *)sender;
- (IBAction)filterEnquiryType:(UIButton *)sender;
- (IBAction)filterTimeType:(UIButton *)sender;
@end
