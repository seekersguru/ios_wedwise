//
//  WWPrivateMessage.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWPrivateMessage.h"
#import "SenderMsgCell.h"
#import "ReceiverMsgCell.h"

@interface WWPrivateMessage ()
{
    NSMutableArray *chatArray;
    __block NSString *globalLastMessageID;
    NSTimer *myTimer;
    NSString *minID;
    NSString *maxID;
    NSString *assignValue;
    
}



@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation WWPrivateMessage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    maxID= @"";
    minID= @"";
    
    assignValue= @"3";
    
    [self.lblVendorName setFont:[UIFont fontWithName:AppFont size:15.0f]];
    self.lblVendorName.text = [_messageData valueForKey:@"receiver_name"];
    
    self.senderId = @"1";
    self.senderDisplayName = @"";
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.showLoadEarlierMessagesHeader = YES;
    [self.lblLoading setHidden:YES];
    
    chatArray = [[NSMutableArray alloc] init];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [chatArray removeAllObjects];
    [self callPrivateChatAPI:@"" withMinID:@"" withMaxID:@""];
    
    myTimer =[NSTimer scheduledTimerWithTimeInterval: 1220.0 target: self
                                            selector: @selector(callPrivateChatAPI:) userInfo: @"" repeats: YES];
}
- (void)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)nextButtonAction:(id)sender{
    JSQMessage *previousMessage = [chatArray lastObject];
    maxID= [NSString stringWithFormat:@"%@",previousMessage.messageId];
    minID=@"";
    [self callPrivateChatAPI:@"" withMinID:minID withMaxID:maxID];
}
-(IBAction)previousButtonAction:(id)sender{
    JSQMessage *previousMessage = [chatArray firstObject];
    minID= [NSString stringWithFormat:@"%@",previousMessage.messageId];
    maxID=@"";
    [self callPrivateChatAPI:@"" withMinID:minID withMaxID:maxID];
    
}
- (void)refreshMessageAction:(id)sender{
    
}

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    self.showTypingIndicator = !self.showTypingIndicator;
    [self scrollToBottomAnimated:YES];
    
    JSQMessage *copyMessage = [[chatArray lastObject] copy];
    
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:@"1"
                                          displayName:@"shivam"
                                                 text:@"First received!"
                                            messageId:@""];
    }
    
    [chatArray addObject:copyMessage];
    [self finishReceivingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    NSString *messageId = @"1";
    if (chatArray.count > 0) {
        messageId = [[chatArray lastObject] messageId];
    }
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text
                                                     messageId:messageId];
    
    [chatArray addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
    NSDictionary *requestDict = @{@"identifier" : [[NSUserDefaults standardUserDefaults]
                                                   stringForKey:@"identifier"],
                                  @"receiver_email" : [_messageData valueForKey:@"receiver_email"],
                                  @"message" : text,
                                  @"from_to" : @"v2c",
                                  @"action" : @"customer_vendor_message_create",
                                  @"mode" : @"ios",
                                  @"device_id" : @"123123",
                                  @"push_data" : text,
                                  @"msg_type" : @"message",
                                  @"event_date" : @"",    //TODO:date should be dynamic, Will do later
                                  @"bid_json" : @"",
                                  @"time_slot" : @"",
                                  @"bid_price" : @"",
                                  @"bid_quantity" : @""};
    
    [[WWWebService sharedInstanceAPI] callWebService:requestDict imgData:nil loadThreadWithCompletion:^(NSDictionary *response) {
        if([[response valueForKey:@"result"] isEqualToString:@"error"]){
            [[WWCommon getSharedObject]createAlertView:kAppName :[response valueForKey:@"message"] :nil :000 ];
            [chatArray removeObject:message];
            [self finishReceivingMessageAnimated:YES];
        }
        else if ([[response valueForKey:@"result"] isEqualToString:@"success"]){
        }
    } failure:^(NSString *failureResponse) {
        [chatArray removeObject:message];
        [self finishReceivingMessageAnimated:YES];
    }];
    
}
-(void)callPrivateChatAPI:(NSString *)lastMessageId withMinID:(NSString*)minIDs withMaxID:(NSString*)maxIDs{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 [_messageData valueForKey:@"receiver_email"],@"receiver_email",
                                 @"1",@"page_no",
                                 @"v2c",@"from_to",
                                 @"customer_vendor_message_detail",@"action",
                                 @"message",@"msg_type",
                                 lastMessageId,@"min",
                                 @"",@"max",
                                 @"",@"last_message_id",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             
             NSArray *arrData=[responseDics valueForKey:@"json"];
             NSDateFormatter *df = [[NSDateFormatter alloc] init];
             [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
             
             __block NSString *strMessageID;
            // [chatArray removeAllObjects];
             
             if(arrData.count>0){
                 [self.lblLoading setHidden:NO];
                 
                 
                 if(minID.length>0)
                     self.lblLoading.text=@"Previeous record loaded.";
                 
                 else if (maxID.length>0)
                     self.lblLoading.text=@"Next record loaded.";
                 
                 
                 for (int i = arrData.count-1; i >= 0; i--) {
                     NSDictionary *arrMessages = [arrData objectAtIndex:i];
                     NSString *senderId = @"1";
                     if ([[arrMessages valueForKey:@"from_to"] isEqualToString:@"c2v"]) {
                         senderId = @"2";
                     }
                     NSString *vendorName = [arrMessages valueForKey:@"vendor_name"];
                     NSString *text = [arrMessages valueForKey:@"message"];
                     NSString *messageId = [NSString stringWithFormat:@"%ld",[[arrMessages valueForKey:@"id"] longValue]];
                     NSDate *date = [df dateFromString:[arrMessages valueForKey:@"msg_time"]];
                     JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                                              senderDisplayName:vendorName
                                                                           date:date
                                                                           text:text
                                                                      messageId:messageId];
                     
                     if(strMessageID.length==0){
                         strMessageID = messageId;
                     }
                     
                     
                     if(minID.length>0)
                         [chatArray insertObject:message atIndex:0];
                     
                     else if (maxID.length>0)
                         [chatArray insertObject:message atIndex:chatArray.count];
                     else
                         [chatArray insertObject:message atIndex:0];
                 }
                 if([globalLastMessageID isEqualToString:strMessageID]){
                     //No need to refresh table
                 }
                 else{
                     //Refresh table
                     globalLastMessageID = strMessageID;
                     strMessageID=@"";
                     [self finishReceivingMessage];
                     [self.lblLoading setHidden:YES];
                 }
             }
             else{
                 self.lblLoading.text=@"No record found";
             }
             
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(IBAction)loadPreviousMessages:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    NSString *lastMessageId = @"";
    if (chatArray.count > 0) {
        JSQMessage *firstMessage = [chatArray firstObject];
        lastMessageId = [NSString stringWithFormat:@"%@",firstMessage.messageId];
        
    }
    [self callPrivateChatAPI:lastMessageId withMinID:minID withMaxID:maxID];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [chatArray objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [chatArray objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [chatArray objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [chatArray objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [chatArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [chatArray count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [chatArray objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [chatArray objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [chatArray objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
    NSString *lastMessageId = @"";
    if (chatArray.count > 0) {
        JSQMessage *firstMessage = [chatArray firstObject];
        lastMessageId = [NSString stringWithFormat:@"%@",firstMessage.messageId];
    
    }
    [self callPrivateChatAPI:lastMessageId withMinID:minID withMaxID:maxID];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

- (void)didPressAccessoryButton:(UIButton *)sender{
    return;
}

@end
