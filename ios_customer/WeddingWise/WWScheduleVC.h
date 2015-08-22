//
//  WWScheduleVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWScheduleVC : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;

- (IBAction)scheduleVisitAction:(id)sender;

@end
