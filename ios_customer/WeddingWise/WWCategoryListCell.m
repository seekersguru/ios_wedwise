//
//  WWCategoryListCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryListCell.h"
#import "WWCategoryCommonCell.h"

@implementation WWCategoryListCell 
{
    NSArray *_descData;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getDescriptionData:(NSArray*)descData{
    
    _descData=[[NSArray alloc]init];
    _descData= descData;//[descData objectAtIndex:0];
    [_tblList reloadData];

}
-(IBAction)readMorePressed:(id)sender{
    [self.delegate showCategryReadMoreView:sender];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WWCategoryCommonCell";
    WWCategoryCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    NSDictionary *dicData= [_descData objectAtIndex:indexPath.row];
    [cell setCommonData:dicData withIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _descData.count;
}

@end
