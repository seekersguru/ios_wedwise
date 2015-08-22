//
//  UITextField+ADTextField.m
//  AirDates
//
//  Created by Deepak Sharma on 5/13/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import "UITextField+ADTextField.h"

@implementation UITextField (ADTextField)

-(void)setTextFieldPlaceholder:(NSString*)string withcolor:(UIColor*)color withPadding:(UITextField*)textField{
     self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName: color}];
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 18)];
//    textField.leftView = paddingView;
//    textField.leftViewMode = UITextFieldViewModeAlways;
}
@end
