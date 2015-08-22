//
//  WWCategoryListCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CategryDetailCellDelegate <NSObject>
-(void)showCategryReadMoreView:(id)sender;
@required

@end

@interface WWCategoryListCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    id <CategryDetailCellDelegate> _delegate;
}

@property(nonatomic, strong)IBOutlet UITableView *tblList;
@property(nonatomic, weak)IBOutlet UILabel *lblHeading;
@property(nonatomic, weak)IBOutlet UIButton *btnReadMore;




-(IBAction)readMorePressed:(id)sender;
@property (nonatomic,strong) id delegate;

-(void)getDescriptionData:(NSArray*)descData;

@end
