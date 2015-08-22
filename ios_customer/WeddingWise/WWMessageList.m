//
//  WWMessageList.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWMessageList.h"
#import "MessageListCell.h"
#import "WWPrivateMessage.h"
#import "WWCreateBidVC.h"
#import "WWProfileVC.h"

@interface WWMessageList ()<MBProgressHUDDelegate>
{
    NSMutableArray *arrMessageData;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation WWMessageList
- (void)awakeFromNib{
//    WWProfileVC *profileVc=[[WWProfileVC alloc]initWithNibName:@"WWProfileVC" bundle:nil];
//    [self.navigationController pushViewController:profileVc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [messageTable registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    bidBtn.selected = YES;
    
    arrMessageData=[[NSMutableArray alloc]init];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callCustomerMessageAPI:) onTarget:self withObject:@"" animated:YES];
    
    
    [bidBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    [bookBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    [messageBtn.titleLabel setFont:[UIFont fontWithName:AppFont size:17.0f]];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setBackgroundColor:[UIColor whiteColor]];
    [_refreshControl setTintColor:[UIColor lightGrayColor]];
    [_refreshControl addTarget:self action:@selector(loadPrevioudMessages:) forControlEvents:UIControlEventValueChanged];
    [messageTable addSubview:_refreshControl];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)loadPrevioudMessages:(id)sender{
    [messageTable reloadData];
    if (_refreshControl) {
        [_refreshControl endRefreshing];
    }
}

-(IBAction)loadMoreButtonPressed:(id)sender{
    NSDictionary *messageData=[arrMessageData lastObject];
    
    [self callCustomerMessageAPI:[NSString stringWithFormat:@"%@",messageData[@"id"]]];
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
-(void)callCustomerMessageAPI:(NSString*)minValue{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"customer_vendor_message_list",@"action",
                                 @"c2v",@"from_to",
                                 @"",@"max",
                                 minValue,@"min",
                                 @"",@"sort",
                                 @"message",@"msg_type",
                                 nil];
    
    
    
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[responseDics valueForKey:@"json"];
             
             for (NSDictionary *arrMessages in arrData) {
                 
                 [arrMessageData insertObject:arrMessages atIndex:0];
                 //[arrMessageData addObject:arrMessages];
             }
             
             
             
             [messageTable reloadData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
