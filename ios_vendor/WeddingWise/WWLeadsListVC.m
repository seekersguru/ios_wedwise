//
//  WWLeadsListVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLeadsListVC.h"
#import "WWBidListCell.h"
#import "WWInquiryDetailVC.h"
#import <math.h>

#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0);

@interface WWLeadsListVC ()

@end

@implementation WWLeadsListVC
{
    NSMutableArray *arrBidData;
    __block NSString *sortType;
    
    BOOL isSorting;
}

#pragma mark Viewlife cycle methods:
- (void)viewDidLoad {
    [super viewDidLoad];
    sortType= @"";
    
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_lblSortBy withText:_lblSortBy.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_sortEventButton withText:_sortEventButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_sortInquiryButton withText:_sortInquiryButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:bidBtn withText:bidBtn.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:bookBtn withText:bookBtn.titleLabel.text];
    
    _tblBidView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.navigationController.navigationBar setHidden:YES];
    [_tblBidView registerNib:[UINib nibWithNibName:@"WWBidListCell" bundle:nil] forCellReuseIdentifier:@"WWBidListCell"];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    arrBidData=[[NSMutableArray alloc]init];
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:0.0 y:0.0];
    [self callBidDetailAPI:@"bid"];
}

#pragma mark IBaction & Utility methods:
-(IBAction)bidBtnClicked:(id)sender
{
    bidBtn.selected = YES;
    bookBtn.selected = NO;
    [self callBidDetailAPI:@"bid"];
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:0.0 y:0.0];
}
-(IBAction)bookBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    // Move the image
    [self callBidDetailAPI:@"book"];
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:bookBtn.frame.origin.x y:0.0];
}
- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}
-(void)callBidDetailAPI:(NSString*)type{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"v2c",@"from_to",
                                 type,@"msg_type",
                                 @"customer_vendor_message_list",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [arrBidData removeAllObjects];
             NSArray *arrJson=[responseDics valueForKey:@"json"];
             for (NSDictionary *bidData in arrJson) {
                 [arrBidData addObject:bidData];
             }
             [_tblBidView reloadData];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (IBAction)eventDateSorting:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        if(_sortEventButton.selected){
            _imgEvent.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(360));
            _sortEventButton.selected= NO;
        }
        else{
            _imgEvent.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(180));
            _sortEventButton.selected= YES;
        }
    }];
    arrBidData= [self sortListing:@"msg_time" withOrder:_sortEventButton.selected withData:arrBidData];
    [_tblBidView reloadData];
    
}
-(IBAction)loadMoreButtonPressed:(id)sender{
    NSDictionary *dicBidData = [arrBidData firstObject];
    NSDictionary *dicBidData2 = [arrBidData lastObject];
    isSorting= NO;
    
    [self callEventSortingAPI:sortType withMax:dicBidData[@"id"] withMin:dicBidData2[@"id"]];
}
-(void)callEventSortingAPI:(NSString*)sort withMax:(NSString*)max withMin:(NSString*)min{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"v2c",@"from_to",
                                 @"bid",@"msg_type",
                                 max,@"max",
                                 min,@"min",
                                 sortType,@"sort",
                                 @"customer_vendor_message_list",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //[arrBidData removeAllObjects];
             NSArray *arrJson=[responseDics valueForKey:@"json"];
             
             if(isSorting){
                 [arrBidData removeAllObjects];
             }
             
             NSMutableArray *arrtTemp = [[NSMutableArray alloc]init];
             
             for (NSDictionary *bidData in arrJson) {
                 
                 
                 if([responseDics[@"append"] isEqualToString:@"1"])
                 {
                     
                     [arrtTemp addObject:bidData];
                     
                 }
                 else{
                     [arrtTemp insertObject:bidData atIndex:0];
                 }
                 
                 
             }
             [arrtTemp addObjectsFromArray:arrBidData];
             
             NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"msg_time" ascending:NO];
             NSMutableArray *sortDescriptors = (NSMutableArray*)[NSArray arrayWithObject:brandDescriptor];
             arrtTemp = (NSMutableArray*)[arrtTemp sortedArrayUsingDescriptors:sortDescriptors];
             
             arrBidData= arrtTemp;
             
             [_tblBidView reloadData];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

- (IBAction)inquiryDateSorting:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        if(_sortInquiryButton.selected){
            _imgInquiry.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(360));
            _sortInquiryButton.selected= NO;
            //sortType = @"msg_time";
        }
        else{
            _imgInquiry.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(180));
            _sortInquiryButton.selected= YES;
            //sortType= @"-msg_time";
        }
    }];
    isSorting= YES;
    
    
    
    arrBidData= [self sortListing:@"event_date" withOrder: _sortInquiryButton.selected withData:arrBidData];
    
    [_tblBidView reloadData];
}
-(NSMutableArray*)sortListing: (NSString*)sortingType withOrder:(BOOL)order withData:(NSMutableArray*)bidData{
    
    NSMutableArray *arrtTemp= [[NSMutableArray alloc]init];
    arrtTemp= bidData;
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingType ascending:order];
    NSMutableArray *sortDescriptors = (NSMutableArray*)[NSArray arrayWithObject:brandDescriptor];
    arrtTemp = (NSMutableArray*)[arrtTemp sortedArrayUsingDescriptors:sortDescriptors];
    
    return arrtTemp;
}

#pragma mark UITableView delgate & datasource methods:
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWBidListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWBidListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[arrBidData objectAtIndex:indexPath.row]];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrBidData.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WWInquiryDetailVC *inqDetail=[[WWInquiryDetailVC alloc]initWithNibName:@"WWInquiryDetailVC" bundle:nil];
    inqDetail.messageData= [arrBidData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:inqDetail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
