//
//  WWFavoriteVendorsVC.m
//  WedWise
//
//  Created by Deepak Sharma on 8/10/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWFavoriteVendorsVC.h"
#import "WWCategoryCell.h"
#import "WWCategoryDetailVC.h"

@interface WWFavoriteVendorsVC ()<MBProgressHUDDelegate>
{
    NSMutableArray *arrVendorData;
    
}
@end

@implementation WWFavoriteVendorsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrVendorData=[[NSMutableArray alloc]init];
    _tblCategory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_lblTitle setFont:[UIFont fontWithName:AppFont size:17.0f]];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callWebService) onTarget:self withObject:nil animated:YES];
    
    //[self callWebService];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callWebService{
    
//    [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 @"1",@"page_no",
                                 @"",@"search_string",
                                 @"1",@"favorites",
                                 @"Banquets",@"vendor_type",
                                 @"customer_vendor_list_and_search",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         [arrVendorData removeAllObjects];
         if(responseDics.count>0){
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"vendor_list"];
                 for (NSDictionary *dicVendor in arrData){
                     [arrVendorData addObject:dicVendor];
                 }
             }
         }
         else{
             [[WWCommon getSharedObject]createAlertView:kAppName :@"No data found." :nil :000 ];
         }
         
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [_tblCategory reloadData];
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WWCategoryCell";
    WWCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dicVendorData=[[arrVendorData objectAtIndex:indexPath.row] mutableCopy];
    cell.favoriteDelegate= self;
    cell.btnFavorite.tag= indexPath.row;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[dicVendorData valueForKey:@"image"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    
    if([dicVendorData[@"favorite"] isEqualToString:@"1"]){
        [cell.btnFavorite setImage:[UIImage imageNamed:@"RSelect"] forState:UIControlStateNormal];
    }
    else if ([dicVendorData[@"favorite"] isEqualToString:@"-1"]){
        [cell.btnFavorite setImage:[UIImage imageNamed:@"WSelect"] forState:UIControlStateNormal];
    }
    
    __weak WWCategoryCell *weakCell = cell;
    
    [cell.imgCategory setImageWithURLRequest:request
                            placeholderImage:placeholderImage
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         weakCell.imgCategory.image = image;
                                         [weakCell setNeedsLayout];
                                         
                                     } failure:nil];
    
    cell.lblName.text=[dicVendorData valueForKey:@"name"];
    cell.lblStartingPrice.text=[NSString stringWithFormat:@"%@/-",[dicVendorData valueForKey:@"starting_price"]];
    
    cell.lblName.font = [UIFont fontWithName:AppFont size:12.0];
    cell.lblStartingPrice.font = [UIFont fontWithName:AppFont size:14.0];
    cell.lblCapacity.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lblVeg.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lbl3.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lbl4.font = [UIFont fontWithName:AppFont size:10.0];
    
    NSArray *arrLine1=[dicVendorData valueForKey:@"icons_line1"];
    for (int i=0; i<arrLine1.count; i++) {
        NSDictionary *line1= arrLine1[i];
        switch (i) {
            case 0:{
                cell.lblVeg.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img1 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img1.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                
                
                break;
            case 1:
            {
                cell.lblCapacity.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                //cell.lblVeg.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img2 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img2.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            default:
                break;
        }
    }
    NSArray *arrLine2=[dicVendorData valueForKey:@"icons_line2"];
    for (int i=0; i<arrLine2.count; i++) {
        NSDictionary *line1= arrLine2[i];
        switch (i) {
            case 0:
            {
                cell.lbl3.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img3 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img3.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            case 1:
            {
                cell.lbl4.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img4 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img4.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            default:
                break;
        }
    }
    self.tblCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    if (indexPath.row == [arrVendorData count] - 1)
//    {
//        [self callWebService];
//    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrVendorData.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WWCategoryDetailVC *detailScreen=[[WWCategoryDetailVC alloc]initWithNibName:@"WWCategoryDetailVC" bundle:nil];
    detailScreen.hidesBottomBarWhenPushed = YES;
    detailScreen.vendorEmail=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"vendor_email"];
    detailScreen.vendorName=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"name"];
    [self.navigationController pushViewController:detailScreen animated:YES];
    detailScreen.hidesBottomBarWhenPushed = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addFavorites:(id)sender{

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
