//
//  WWCategoryDetailVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/16/15.
//  Copyright (c) 2015 Deepak Sharma. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WWCategoryDetailVC.h"

#import "WWCategoryTitleCell.h"
#import "WWCategoryImageCell.h"
#import "WWCategoryDescriptionCell.h"
#import "WWCategoryMapCell.h"
#import "WWVendorDetailData.h"

#import "WWCategoryListCell.h"
#import "WWCategoryCommonCell.h"

#import "WWCreateBidVC.h"
#import "WWPrivateMessage.h"
#import "WWScheduleVC.h"
#import "AnnotationPin.h"
#import "WWProfileVC.h"
#import "WWMessageList.h"
#import "WWDashboardVC.h"
#import "WWVendorParaCell.h"

#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0)
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface WWCategoryDetailVC ()<DescriptionDelegate, MapCellDelegate,ImageCellDelegate, MBProgressHUDDelegate, UIWebViewDelegate>
{
    NSMutableArray *arrVendorDetailData;
    NSArray *arrReadMoreData;
    NSString *tempFavorite;
    UIView* loadingView;
}
@end

@implementation WWCategoryDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    arrVendorDetailData=[[NSMutableArray alloc]init];
    arrReadMoreData= [[NSArray alloc]init];
    [self setUpCustomView];
    [self callWebService];
    
    _lblTitle.text= _vendorName;
    
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_inquireButton withText:_inquireButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_messageButton withText:_messageButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_scheduleButton withText:_scheduleButton.titleLabel.text];
    
}

-(void)callWebService{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 _vendorEmail,@"vendor_email",
                                 @"customer_vendor_detail",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //setting bid info for this vendor, to use on add bid page
             
             [[AppDelegate sharedAppDelegate]setVendorEmail:_vendorEmail];
             
             
             WWVendorBidData *bidInfo = [WWVendorBidData sharedInstance];
             [bidInfo setVendorBidInfo:responseDics[@"json"][@"data"][@"bid"]];
             
             //setting booking info for this vendor, to use on add booking page
             WWVendorBookingData *bookingInfo = [WWVendorBookingData sharedInstance];
             [bookingInfo setVendorBookingInfo:responseDics[@"json"][@"data"][@"book"]];
             
             WWVendorDetailData *basicInfo = [WWVendorDetailData sharedInstance];
             [basicInfo setVendorBasicInfo:[[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"info"]];
             
             //Set favorite:
             [basicInfo setStrFavorite:[[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"favorite"]];
             
             [basicInfo setVendorEmail:_vendorEmail];   //setting vendor email for post bid
             [arrVendorDetailData addObject:basicInfo];
             
             //NSString *strFavorite = [[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"favorite"];
             
             NSArray *arrSections= [[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"sections"];
             for (int i=0; i<arrSections.count; i++) {
                 
                 NSDictionary *dataDisplay=[arrSections objectAtIndex:i];
                 NSArray *type=[[dataDisplay valueForKey:@"data_display"] valueForKey:@"type"];
                 
                 if([type objectAtIndex:0] !=(id)[NSNull null]){
                     if([[type objectAtIndex:0] isEqualToString:@"key_value"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorDescription *description=[[WWVendorDescription alloc]setVendorDescrition:dataDisplay];
                         [arrVendorDetailData addObject:description];
                     }
                     else if ([[type objectAtIndex:0] isEqualToString:@"map"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorMap *mapData= [[WWVendorMap alloc]setVendorMap:dataDisplay];
                         [arrVendorDetailData addObject:mapData];
                     }
                     else if([[type objectAtIndex:0] isEqualToString:@"para"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorPara *paraData = [[WWVendorPara alloc]setVendorPara:dataDisplay];
                         [arrVendorDetailData addObject:paraData];
                     }
                     else if([[type objectAtIndex:0] isEqualToString:@"packages"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorPackage *description=[[WWVendorPackage alloc]setVendorPackage:dataDisplay];
                         [arrVendorDetailData addObject:description];
                     }
                     
                 }
                 else{
                     
                 }
             }
             _tblCategoryDetail.delegate=self;
             _tblCategoryDetail.dataSource= self;
             [_tblCategoryDetail reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(void)setUpCustomView
{
    _packageView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _descriptionView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _listingView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _mapView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _videoView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    
}-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)hideView:(id)sender{
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _packageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _descriptionView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _listingView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _mapView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _videoView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
    
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView== _tblReadMore){
        static NSString *CellIdentifier = @"WWCategoryCommonCell";
        WWCategoryCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        //243 150 141
        if (isPackage) {
            cell.key.text = @"";
            cell.value.text = @"";
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[[rowsArray objectAtIndex:indexPath.row] valueForKey:@"label"]];
            //cell.textLabel.textColor = [UIColor blackColor];
            for (NSDictionary *dict in originalRowsArray) {
                if ([[dict valueForKey:@"label"] isEqualToString:[[rowsArray objectAtIndex:indexPath.row] valueForKey:@"label"]]) {
                    cell.textLabel.textColor = [UIColor colorWithRed:243.0/255.0 green:150.0/255.0 blue:141.0/255.0 alpha:1.0];
                    [cell.textLabel setFont:[UIFont fontWithName:AppFont size:13.0f]];
                    
                    break;
                }
            }
        }
        else{
            
            NSDictionary *dicData=[arrReadMoreData objectAtIndex:indexPath.row];
            [cell setCommonData:dicData withIndexPath:indexPath];
        }
        return cell;
        
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                static NSString *CellIdentifier = @"WWCategoryTitleCell";
                WWCategoryTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                if(arrVendorDetailData.count>0){
                
                }
                return cell;
            }
                
                break;
            case 1:
            {
                static NSString *CellIdentifier = @"WWCategoryImageCell";
                WWCategoryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                cell.delegate= self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                if(arrVendorDetailData.count>0){
                    WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
                    [cell showImagesFromArray:basicInfo.heroImages];
                    [cell.lblPrice setText:basicInfo.startingPrice];
                    cell.lblPrice.font = [UIFont fontWithName:AppFont size:13.0];
                    
                    
                    
                    if([basicInfo.strFavorite isEqualToString:@"1"]){
                        [cell.btnFavorite setImage:[UIImage imageNamed:@"RSelect"] forState:UIControlStateNormal];
                    }
                    else if ([basicInfo.strFavorite isEqualToString:@"-1"]){
                         [cell.btnFavorite setImage:[UIImage imageNamed:@"WSelect"] forState:UIControlStateNormal];
                    }
                }
                
                return cell;
            }
                break;
            default:
            {
                if(arrVendorDetailData.count>0){
                    @try {
                        
                        id object= [arrVendorDetailData objectAtIndex:indexPath.row-1];
                        if([object isKindOfClass:[WWVendorDescription class]]){
                            static NSString *CellIdentifier = @"WWCategoryListCell";
                            WWCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (cell == nil) {
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                                cell = [topLevelObjects objectAtIndex:0];
                            }
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                            cell.delegate= self;
                            cell.btnReadMore.tag=indexPath.row;
                            
                            WWVendorDescription *descData=(WWVendorDescription*)object;
                            [cell getDescriptionData:descData.arrDescriptionData];
                            cell.lblHeading.text= descData.heading;
                            cell.lblHeading.font = [UIFont fontWithName:AppFont size:12.0];
                            
                            if (descData.descReadMoreData.count==0) {
                                [cell.btnReadMore setHidden:YES];
                            }
                            else{
                                [cell.btnReadMore setHidden:NO];
                            }
                            return cell;
                        }
                        else if ([object isKindOfClass:[WWVendorMap class]]){
                            static NSString *CellIdentifier = @"WWCategoryMapCell";
                            WWCategoryMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (cell == nil) {
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                                cell = [topLevelObjects objectAtIndex:0];
                            }
                            cell.delegate= self;
                            [cell showCoordinatesOnMapWithLatitude:[(WWVendorMap *)object latitude] longitude:[(WWVendorMap *)object longitude]];
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                            return cell;
                        }
                        else if ([object isKindOfClass:[WWVendorPara class]]){
                            static NSString *CellIdentifier = @"WWVendorParaCell";
                            WWVendorParaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (cell == nil) {
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                                cell = [topLevelObjects objectAtIndex:0];
                            }
                            WWVendorPara *descData=(WWVendorPara*)object;
                            cell.heading.text = descData.heading;
                            
                            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                            return cell;
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Exception :%@", exception);
                    }
                    @finally {
                        
                    }
                    
                }
            }
                break;
        }
    }
    
    
    return nil;
}

//cell delegate will be called when user taps on image

- (void)showImagesOnScroll:(NSArray *)images{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:appdelegate.window.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    for (int i = 0; i < images.count; i++) {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,images[i]]];
        
        CGRect frame = CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeCenter;
        UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
        [imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
        [scrollView addSubview:imageView];
    }
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:CGSizeMake(images.count*scrollView.frame.size.width, 0)];
    scrollView.tag = 1000;
    [appdelegate.window addSubview:scrollView];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 30)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [appdelegate.window addSubview:doneButton];
}
- (void)imageSelected:(UIImage *)image{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *zoomImageView = [[UIView alloc] initWithFrame:appdelegate.window.bounds];
    [zoomImageView setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:zoomImageView.frame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = image;
    [zoomImageView addSubview:imageView];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 10, 60, 30)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [zoomImageView addSubview:doneButton];
    
    [appdelegate.window addSubview:zoomImageView];
}

- (void)doneButtonClicked:(UIButton *)bt{
    [[bt.superview viewWithTag:1000] removeFromSuperview];
    [bt removeFromSuperview];
}
BOOL isRowClicked;
NSInteger selectedRow = -1;
NSInteger lastArrayCount = 0;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL shouldSelect = NO;
    for (NSDictionary *dict in originalRowsArray) {
        if ([[dict valueForKey:@"label"] isEqualToString:[[rowsArray objectAtIndex:indexPath.row] valueForKey:@"label"]]) {
            shouldSelect = YES;
            break;
        }
    }
    if (!shouldSelect) {
        return;
    }
    
    
    rowsArray = [originalRowsArray mutableCopy];
    
    if (selectedRow == -1) {
        NSString* key = [[[arrReadMoreData objectAtIndex:0] allKeys] objectAtIndex:indexPath.section];
        NSArray *optionsArray = [[[[[arrReadMoreData objectAtIndex:0] valueForKey:key] valueForKey:@"package_values"] objectAtIndex:indexPath.row] valueForKey:@"options"];
        NSMutableArray *finalOptionsArray = [NSMutableArray new];
        [optionsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [finalOptionsArray addObject:@{@"label" : [NSString stringWithFormat:@"%@ : %@",[obj allKeys][0],[obj allValues][0]]}];
        }];
        NSInteger index = indexPath.row+1;
        for (NSDictionary *dict in finalOptionsArray) {
            [rowsArray insertObject:dict atIndex:index];
            index++;
        }
        lastArrayCount = optionsArray.count;
        selectedRow = indexPath.row;
    }
    else if (selectedRow == indexPath.row){
        //same row selected again
        //hide the additional data
        lastArrayCount = 0;
        selectedRow = -1;
    }
    else if (indexPath.row < selectedRow){
        NSString* key = [[[arrReadMoreData objectAtIndex:0] allKeys] objectAtIndex:indexPath.section];
        NSArray *optionsArray = [[[[[arrReadMoreData objectAtIndex:0] valueForKey:key] valueForKey:@"package_values"] objectAtIndex:indexPath.row] valueForKey:@"options"];
        
        NSMutableArray *finalOptionsArray = [NSMutableArray new];
        [optionsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [finalOptionsArray addObject:@{@"label" : [NSString stringWithFormat:@"%@ : %@",[obj allKeys][0],[obj allValues][0]]}];
        }];
        NSInteger index = indexPath.row+1;
        for (NSDictionary *dict in finalOptionsArray) {
            [rowsArray insertObject:dict atIndex:index];
            index++;
        }
        
        lastArrayCount = optionsArray.count;
        selectedRow = indexPath.row;
    }
    else if (indexPath.row > selectedRow){
        NSString* key = [[[arrReadMoreData objectAtIndex:0] allKeys] objectAtIndex:indexPath.section];
        NSArray *optionsArray = [[[[[arrReadMoreData objectAtIndex:0] valueForKey:key] valueForKey:@"package_values"] objectAtIndex:indexPath.row-lastArrayCount-1] valueForKey:@"options"];
        
        NSMutableArray *finalOptionsArray = [NSMutableArray new];
        [optionsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [finalOptionsArray addObject:@{@"label" : [NSString stringWithFormat:@"%@ : %@",[obj allKeys][0],[obj allValues][0]]}];
        }];
        NSInteger index = indexPath.row-lastArrayCount+1;
        for (NSDictionary *dict in finalOptionsArray) {
            [rowsArray insertObject:dict atIndex:index];
            index++;
        }
        
        lastArrayCount = optionsArray.count;
        selectedRow = indexPath.row-lastArrayCount;
    }
    [_tblReadMore beginUpdates];
    [_tblReadMore reloadSections:[NSIndexSet indexSetWithIndex:selectedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tblReadMore endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tblReadMore && isPackage) {
        return 44;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView== _tblReadMore){
        return 35.0f;
    }
    else{
        switch (indexPath.row) {
            case 0:
                return 0;
                break;
            case 1:
                return 180;
                break;
            default:
            {
                    return 170;
            }
                break;
        }
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView== _tblReadMore){
        if (isPackage) {
            if (isHeaderClicked && selectedSection == section) {
                return rowsArray.count;
            }
            return 0;
        }
        else{
            return arrReadMoreData.count;
        }
    }
    else{
        return arrVendorDetailData.count+1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView== _tblReadMore){
        if (isPackage) {
            return [[arrReadMoreData objectAtIndex:0] count]-1;
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tblReadMore) {
        if (isPackage) {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
//            [bgView setBackgroundColor:[UIColor lightGrayColor]];
            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, bgView.frame.size.width, 1)];
            sepView.backgroundColor = [UIColor lightGrayColor];
            
            UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 43)];
            [headerView setTitle:[[[arrReadMoreData objectAtIndex:0] allKeys] objectAtIndex:section] forState:UIControlStateNormal];
            [headerView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            [headerView addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView setTag:section];
            
            [bgView addSubview:sepView];
            [bgView addSubview:headerView];
            
            return bgView;
        }
    }
    return nil;
}

BOOL isHeaderClicked;
NSInteger selectedSection = -1;
NSMutableArray *rowsArray = nil;
NSArray *originalRowsArray = nil;
- (void)sectionClicked:(UIButton *)button{
    
    //@try {
        isRowClicked = NO;;
        selectedRow = -1;
        lastArrayCount = 0;
        
        NSInteger tag = button.tag;
        if (tag == selectedSection || selectedSection == -1) {
            isHeaderClicked = !isHeaderClicked;
        }
        else if (tag != selectedSection && selectedSection != -1 && !isHeaderClicked){
            isHeaderClicked = YES;
        }
        
        if (!rowsArray) {
            rowsArray = [NSMutableArray new];
        }
        [rowsArray removeAllObjects];
        NSString* key = [[[arrReadMoreData objectAtIndex:0] allKeys] objectAtIndex:tag];
        [rowsArray addObjectsFromArray:[[[[arrReadMoreData objectAtIndex:0] valueForKey:key] valueForKey:@"package_values"] mutableCopy]];
        originalRowsArray = [[[arrReadMoreData objectAtIndex:0] valueForKey:key] valueForKey:@"package_values"];
        [_tblReadMore beginUpdates];
        if (selectedSection != -1) {
            [_tblReadMore reloadSections:[NSIndexSet indexSetWithIndex:selectedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        selectedSection = tag;
        [_tblReadMore reloadSections:[NSIndexSet indexSetWithIndex:selectedSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tblReadMore endUpdates];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Exception :%@", [exception class]);
//    }
//    @finally {
//        
//    }
    
}

#pragma mark: Cell Delegate methods:
BOOL isPackage;
-(void)addFavorites{
    NSLog(@"addFavorites");
    tempFavorite = @"";
    NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"EmailID"];
    if(savedGroomName.length>0){
        WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
        if([basicInfo.strFavorite isEqualToString:@"-1"]){
            //[dicVendorData setValue:@"1" forKey:@"favorite"];
            tempFavorite=@"1";
        }
        else if ([basicInfo.strFavorite isEqualToString:@"1"]){
            //[dicVendorData setValue:@"-1" forKey:@"favorite"];
            tempFavorite=@"-1";
        }
        // [_tblCategory reloadData];
        [self callFavoriteApi:basicInfo withFavorite:tempFavorite];
    }
    else{
        [AppDelegate sharedAppDelegate].isLogOut= YES;
        
        
        WWDashboardVC *dash=[[WWDashboardVC alloc]initWithNibName:@"WWDashboardVC" bundle:nil];
        dash.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dash animated:YES];
    }
}
-(void)callFavoriteApi:(WWVendorDetailData*)dicVendor withFavorite:(NSString*)isFavorite{
    
    NSDictionary *dicParameters= [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"identifier"],@"identifier",
                                  dicVendor.vendorEmail,@"vendor_email",
                                  isFavorite,@"favorite",
                                  @"add_favorite",@"action",nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:dicParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"responseDics :%@",responseDics);
         MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
         [self.view addSubview:HUD];
         
         // Regiser for HUD callbacks so we can remove it from the window at the right time
         HUD.delegate = self;
         
         // Show the HUD while the provided method executes in a new thread
         [HUD showWhileExecuting:@selector(callWebService) onTarget:self withObject:nil animated:YES];
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(void)showCategryReadMoreView:(id)sender{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         UIButton *readMore=sender;
                         WWVendorDescription *descData=[arrVendorDetailData objectAtIndex:readMore.tag-1];
                         arrReadMoreData= nil;
                         isPackage = NO;
                         if (descData.descReadMoreData != (id)[NSNull null] && descData.descReadMoreData.count>0) {
                             if ([descData.type isEqualToString:@"packages"]) {
                                 isPackage = YES;
                                 arrReadMoreData=descData.descReadMoreData;
                             }
                             else{
                                 arrReadMoreData=descData.descReadMoreData;
                             }
                             _lblReadMoreTitle.text=descData.heading;
                             _lblReadMoreTitle.font = [UIFont fontWithName:AppFont size:13.0];
                             
                             _descriptionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
                             _tblReadMore.delegate= self;
                             _tblReadMore.dataSource= self;
                             [_tblReadMore reloadData];
                         }
                         else{
                             [[WWCommon getSharedObject]createAlertView:kAppName :@"No data avalilable" :nil :000 ];
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)showFacilityReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _listingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showPackageReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _packageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showDescriptionReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _descriptionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showMapFullView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         WWVendorMap *mapData = nil;
                         for (id object in arrVendorDetailData) {
                             if ([object isKindOfClass:[WWVendorMap class]]) {
                                 mapData = object;
                                 break;
                             }
                         }
                         
                         if (mapData) {
                             CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([mapData.latitude floatValue], [mapData.longitude floatValue]);
                             AnnotationPin *annotation = [[AnnotationPin alloc] initWithCoordinate:coordinates];
                             [self.map addAnnotation:annotation];
                             
                             MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500);
                             MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
                             [self.map setRegion:adjustedRegion animated:YES];
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)showVideoPlayer{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _webTitle.text= @"Video";
                         
                         WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
                         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:basicInfo.videoLinks[0]]];
                         [_wbView loadRequest:request];
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)show360Image{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _webTitle.text= @"360 Image";
                         
                         loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.videoView.frame.size.width/2-40, self.videoView.frame.size.height/2-40, 80, 80)];
                         
                         loadingView.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:150.0f/255.0f blue:141.0f/255.0f alpha:1.0];
                         loadingView.layer.cornerRadius = 5;
                         
                         UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                         activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
                         [activityView startAnimating];
                         activityView.tag = 100;
                         [loadingView addSubview:activityView];
                         
                         UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
                         lblLoading.text = @"";
                         _wbView.delegate = self;
                         lblLoading.textColor = [UIColor whiteColor];
                         lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
                         lblLoading.textAlignment = NSTextAlignmentCenter;
                         [loadingView addSubview:lblLoading];
                         
                         [self.view addSubview:loadingView];
                         
                         WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
                         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:basicInfo.panormaImages]];
                         [_wbView loadRequest:request];
                         
                         
                     }
                     completion:^(BOOL finished){
                     }];
}
- (IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [loadingView setHidden:NO];
    
}
- (IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}
-(void)bidButtonClicked{
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}
-(void)bookButtonClicked{
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}

- (IBAction)selectCustomBottonAction:(UIButton *)sender {
    
    UIViewController *vc = nil;
    NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"EmailID"];
    if(savedGroomName == nil){
        WWProfileVC *profileVC=[[WWProfileVC alloc]init];
        [self.navigationController pushViewController:profileVC animated:YES];
        
        return;
    }
    else{
        switch (sender.tag) {
            case 1:
                vc=[[WWCreateBidVC alloc]init];
                [(WWCreateBidVC *)vc setRequestType:@"bid"];
                break;
            case 2:
                vc=[[WWCreateBidVC alloc]init];
                [(WWCreateBidVC *)vc setRequestType:@"book"];
                break;
            case 3:
                vc=[[WWPrivateMessage alloc]init];
                [(WWPrivateMessage *)vc setMessageData:@{@"receiver_name" : _vendorName,
                                                         @"receiver_email" : _vendorEmail}];
                break;
            case 4:
                vc=[[WWScheduleVC alloc]init];
                break;
                
            default:
                break;
        }
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
