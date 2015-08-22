//
//  WWBasicDetails.h
//  WeddingWise
//
//  Created by Shivam on 7/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWBasicDetails : NSObject
@property(nonatomic, strong)NSString *calendarDate;
@property(nonatomic, strong)NSDate *currentDateInCalendar;
+ (instancetype)sharedInstance;
@end
