//
//  WWConfig.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWCommon : NSObject
+ (WWCommon *) getSharedObject;

- (void) createAlertView:(NSString *)title :(NSString *)message :(id)delegate :(NSInteger)tagVAlue;
-(BOOL) validEmail:(NSString*) email;
-(void)setCustomFont:(CGFloat)font withLabel:(id)sender withText:(NSString*)text;
@end
