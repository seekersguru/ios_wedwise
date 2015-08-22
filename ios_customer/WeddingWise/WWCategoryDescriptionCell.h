//
//  WWCategoryDescriptionCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DescriptionDelegate <NSObject>

@required
- (void)showDescriptionReadMoreView;

@end

@interface WWCategoryDescriptionCell : UITableViewCell
{
    id <DescriptionDelegate> _delegate;
}
@property(nonatomic, weak)IBOutlet UIButton *btnReadMore;

-(IBAction)readMorePressed:(id)sender;
@property (nonatomic,strong) id delegate;

@end
