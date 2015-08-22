//
//  WWConfig.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCommon.h"
#import <UIKit/UIKit.h>


@implementation WWCommon
static  WWCommon *sharedObj = nil;
+ (WWCommon *) getSharedObject
{
    @synchronized(self) {
        if(sharedObj == nil)
            sharedObj = [[WWCommon alloc] init];
    }
    return sharedObj;
}
- (void) createAlertView:(NSString *)title :(NSString *)message :(id)delegate :(NSInteger)tagVAlue{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag=tagVAlue;
        [alert show];
    });
    
}
#pragma mark check email id validity method:
-(BOOL) validEmail:(NSString*) email {
    
    if( (0 != [email rangeOfString:@"@"].length) &&  (0 != [email rangeOfString:@"."].length) )
    {
        NSMutableCharacterSet *invalidCharSet = [[[NSCharacterSet alphanumericCharacterSet] invertedSet]mutableCopy];
        [invalidCharSet removeCharactersInString:@"_-"];
        
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        // If username part contains any character other than "."  "_" "-"
        
        NSString *usernamePart = [email substringToIndex:range1.location];
        NSArray *stringsArray1 = [usernamePart componentsSeparatedByString:@"."];
        for (NSString *string in stringsArray1) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet: invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        NSString *domainPart = [email substringFromIndex:range1.location+1];
        NSArray *stringsArray2 = [domainPart componentsSeparatedByString:@"."];
        
        for (NSString *string in stringsArray2) {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:invalidCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else // no '@' or '.' present
        return NO;
}
-(void)setCustomFont:(CGFloat)fontNew withLabel:(id)sender withText:(NSString*)text{
    if([sender isKindOfClass:[UIButton class]]){
        UIButton *btnType=(UIButton*)sender;
        [btnType.titleLabel setFont:[UIFont fontWithName:AppFont size:fontNew]];
        [btnType setTitle:text forState:UIControlStateNormal];
    }
    else if ([sender isKindOfClass:[UILabel class]]){
        UILabel *lblType= (UILabel*)sender;
        lblType.font = [UIFont fontWithName:AppFont size:fontNew];
        [lblType setText:text];
    }
    else if ([sender isKindOfClass:[UITextField class]]){
        UITextField *txtType= (UITextField*)sender;
        txtType.font = [UIFont fontWithName:AppFont size:fontNew];
        
    }
}
@end
