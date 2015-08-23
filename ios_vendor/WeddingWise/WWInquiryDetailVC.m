//
//  WWInquiryDetailVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWInquiryDetailVC.h"
#import "WWInquiryCell.h"

@interface WWInquiryDetailVC ()
{
    NSMutableArray *arrBidData;
}
@end

@implementation WWInquiryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self callBidDetailAPI];
    arrBidData= [NSMutableArray new];
    
    tblInquery.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [btnAccept setHidden:NO];
    [lblStatus setFont:[UIFont fontWithName:AppFont size:15.0]];
    [btnAccept.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [btnDecline.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [btnAccept.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [btnOnHold.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    
    [lblStatus setText:_messageData[@"status"]];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)acceptButtonClicked:(id)sender{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 _messageData[@"id"],@"msg_id",
                                 @"v2c",@"from_to",
                                 @"vendor_bid_book_response",@"action",
                                 @"1",@"status",
                                 nil];
    
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [self.navigationController popViewControllerAnimated:YES];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];

    
}
-(IBAction)declineButtonClicked:(id)sender{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 _messageData[@"id"],@"msg_id",
                                 @"v2c",@"from_to",
                                 @"vendor_bid_book_response",@"action",
                                 @"0",@"status",
                                 nil];
    
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [self.navigationController popViewControllerAnimated:YES];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(IBAction)onHoldButtonClicked:(id)sender{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 _messageData[@"id"],@"msg_id",
                                 @"v2c",@"from_to",
                                 @"vendor_bid_book_response",@"action",
                                 @"2",@"status",
                                 nil];
    
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [self.navigationController popViewControllerAnimated:YES];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WWInquiryCell";
    WWInquiryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell setDetailData:[arrBidData objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)callBidDetailAPI{

    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 _messageData[@"id"] ,@"msg_id",
                                 @"v2c",@"from_to",
                                 @"vendor_bid_book_detail",@"action",
                                 [_messageData valueForKey:@"msg_type"],@"msg_type",
                                 nil];
    
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrJson=[responseDics valueForKey:@"json"][@"table"];
             for (NSDictionary *bidData in arrJson) {
                 [arrBidData addObject:bidData];
             }
             [tblInquery reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrBidData.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
