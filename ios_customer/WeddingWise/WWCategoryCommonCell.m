//
//  WWCategoryCommonCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryCommonCell.h"

@implementation WWCategoryCommonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCommonData:(NSDictionary*)dicData withIndexPath:(NSIndexPath*)index
{
    if([[NSString stringWithFormat:@"%@",[dicData valueForKey:[[dicData allKeys] objectAtIndex:0]]] isEqualToString:@"YES"]){
        [_imgCheck setImage:[UIImage imageNamed:@"Sright"]];
        [_value setHidden:YES];
        [_imgCheck setHidden:NO];
    }
    else if ([[NSString stringWithFormat:@"%@",[dicData valueForKey:[[dicData allKeys] objectAtIndex:0]]] isEqualToString:@"NO"]){
        [_imgCheck setImage:[UIImage imageNamed:@"Sclose"]];
        [_value setHidden:YES];
        [_imgCheck setHidden:NO];
    }
    else{
        _value.text=[NSString stringWithFormat:@"%@",[dicData valueForKey:[[dicData allKeys] objectAtIndex:0]]];
        
        
        [_value setHidden:NO];
        [_imgCheck setHidden:YES];
    }
    
    if (_value.text.length== 0) {
        [_key setTextColor:[UIColor darkGrayColor]];
        [_key setFrame:CGRectMake(_key.frame.origin.x, _key.frame.origin.y, _key.frame.origin.x, _key.frame.size.height)];
    }
    
    _key.text=[NSString stringWithFormat:@"%@",[[dicData allKeys] objectAtIndex:0]];
    _key.font = [UIFont fontWithName:AppFont size:12.0];
    _value.font = [UIFont fontWithName:AppFont size:12.0];
    
    
}
@end
