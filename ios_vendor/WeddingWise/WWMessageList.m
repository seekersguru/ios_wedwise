//
//  WWMessageList.m
//  WeddingWise
//
//  Created by Dotsquares on 6/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWMessageList.h"
#import "MessageListCell.h"
#import "WWPrivateMessage.h"
#import "WWCreateBidVC.h"
#import "WWBasicDetails.h"

@interface WWMessageList ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrMessageData;
    NSString* max;
    NSString* min;
    NSString *calendarDate;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation WWMessageList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setHidden:YES];
    
    messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [messageTable registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    bidBtn.selected = YES;
    
    arrMessageData=[[NSMutableArray alloc]init];
    
    [bidBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    [bookBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    [messageBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setBackgroundColor:[UIColor whiteColor]];
    [_refreshControl setTintColor:[UIColor lightGrayColor]];
    [_refreshControl addTarget:self action:@selector(loadMoreOnTop) forControlEvents:UIControlEventValueChanged];
    [messageTable addSubview:_refreshControl];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [arrMessageData removeAllObjects];
    [messageTable reloadData];
    max = @"";
    min = @"";
    calendarDate = [[WWBasicDetails sharedInstance] calendarDate];
    
    [self callCustomerMessageAPI:^(NSArray *messageArray) {
        [arrMessageData addObjectsFromArray:messageArray];
        [messageTable reloadData];
    }];
    
}

- (void)loadMoreOnTop{
    min = [[arrMessageData firstObject] valueForKey:@"id"];
    max = @"";
    [self callCustomerMessageAPI:^(NSArray *messageArray) {
        for (int i = messageArray.count-1; i >= 0; i--) {
            [arrMessageData insertObject:messageArray[i] atIndex:0];
        }
        [messageTable reloadData];
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
    }];
    
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
-(IBAction)bidBtnClicked:(id)sender
{
    btnCreateBid.hidden= NO;
    [btnCreateBid setTitle:@"Create a new Bid" forState:UIControlStateNormal];
    [btnCreateBid setTag:1];    //if 1 then pass bid in requestType in WWCreateBidVC
    bidBtn.selected = YES;
    bookBtn.selected = NO;
    messageBtn.selected = NO;
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:bidBtn.frame.origin.x y:0.0];
    
    [messageTable setFrame:CGRectMake(messageTable.frame.origin.x, btnCreateBid.frame.origin.y + btnCreateBid.frame.size.height+10, messageTable.frame.size.width, self.view.frame.size.height-175)];
    
}
-(IBAction)bookBtnClicked:(id)sender
{
    btnCreateBid.hidden= NO;
    [btnCreateBid setTitle:@"Create a new Booking" forState:UIControlStateNormal];
    [btnCreateBid setTag:2];     //if 1 then pass bid in requestType in WWCreateBidVC
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    messageBtn.selected = NO;
    
    // Move the image
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:bookBtn.frame.origin.x y:0.0];
    
    [messageTable setFrame:CGRectMake(messageTable.frame.origin.x, btnCreateBid.frame.origin.y + btnCreateBid.frame.size.height+10, messageTable.frame.size.width, self.view.frame.size.height-175)];
}

-(IBAction)messageBtnClicked:(id)sender
{
    btnCreateBid.hidden= YES;
    bidBtn.selected = NO;
    bookBtn.selected = NO;
    
   
    
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:messageBtn.frame.origin.x y:0.0];
    if (!messageBtn.selected) {
        messageBtn.selected = YES;
        [messageTable setFrame:CGRectMake(messageTable.frame.origin.x, selectorImage.frame.origin.y + selectorImage.frame.size.height+15, messageTable.frame.size.width, messageTable.frame.size.height+ 40)];
    }
    
}
-(void)callCustomerMessageAPI:(void(^)(NSArray *))completion{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"customer_vendor_message_list",@"action",
                                 @"v2c",@"from_to",
                                 @"message",@"msg_type",
                                 calendarDate?calendarDate:@"",@"date",
                                 min,@"min",
                                 max,@"max",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[responseDics valueForKey:@"json"];
             completion(arrData);
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Tableview delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMessageData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==messageTable)
    {
        MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *messageData=[arrMessageData objectAtIndex:indexPath.row];
        cell.usernameLbl.text=[messageData valueForKey:@"receiver_name"];
        cell.descLbl.text=[messageData valueForKey:@"message"];
        cell.timeLbl.text= [messageData valueForKey:@"msg_time"];
        
        cell.usernameLbl.font = [UIFont fontWithName:AppFont size:14.0];
        cell.descLbl.font = [UIFont fontWithName:AppFont size:12.0];
        cell.timeLbl.font = [UIFont fontWithName:AppFont size:12.0];
        
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWPrivateMessage *messageVc = [[WWPrivateMessage alloc] initWithNibName:@"WWPrivateMessage" bundle:nil];
    NSDictionary *messageData=[arrMessageData objectAtIndex:indexPath.row];
    messageVc.messageData =messageData;
    messageVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVc animated:YES];
    messageVc.hidesBottomBarWhenPushed = NO;
}

- (void)loadMoreOnBottom{
    max = [[arrMessageData lastObject] valueForKey:@"id"];
    min = @"";
    [self callCustomerMessageAPI:^(NSArray *messageArray) {
        [arrMessageData addObjectsFromArray:messageArray];
        [messageTable reloadData];
        if (arrMessageData.count*70 > messageTable.frame.size.height) {
            [messageTable setContentOffset:CGPointMake(0, (messageTable.contentSize.height - messageTable.frame.size.height))];
        }
    }];
}

-(IBAction)loadMorePressed:(id)sender{
    max = [[arrMessageData lastObject] valueForKey:@"id"];
    min = @"";
    [self callCustomerMessageAPI:^(NSArray *messageArray) {
        [arrMessageData addObjectsFromArray:messageArray];
        [messageTable reloadData];
        if (arrMessageData.count*70 > messageTable.frame.size.height) {
            [messageTable setContentOffset:CGPointMake(0, (messageTable.contentSize.height - messageTable.frame.size.height))];
        }
    }];
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
