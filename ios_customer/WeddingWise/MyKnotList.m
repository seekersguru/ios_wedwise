//
//  ViewController.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "MyKnotList.h"
#import "myKnotCell.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "WWDetailScreen.h"
#import "AppDelegate.h"
#import "WWDashboardVC.h"
#import "WWSideMenuVC.h"

@interface MyKnotList ()<MBProgressHUDDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,UITabBarControllerDelegate>
{
    NSMutableArray *arrCategoryImages;
}
@end

@implementation MyKnotList

NSUInteger lastSelectedIndex = 0;

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 3) {
        self.tabBarController.selectedIndex = lastSelectedIndex;
        UIViewController *fourthViewController = [[WWSideMenuVC alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:fourthViewController];
        [self presentViewController:navC animated:YES completion:nil];
    }
    else{
        lastSelectedIndex = tabBarController.selectedIndex;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
    arrCategoryImages=[[NSMutableArray alloc]init];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callWebService) onTarget:self withObject:nil animated:YES];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
        
        return NO;
        
    } else {
        
        return YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)callWebService{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 @"customer_vendor_category_or_home",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"data"];
             
             for (NSArray *arrImage in arrData) {
                 [arrCategoryImages addObject:arrImage];
             }
             [_tblMyKnotList reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myKnotCell";
    myKnotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell.imgBottom setFrame:CGRectMake(cell.imgBottom.frame.origin.x, cell.imgBottom.frame.origin.y, cell.imgBottom.frame.size.width, cell.imgBottom.frame.size.height)];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.tblMyKnotList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *arrObject=[arrCategoryImages objectAtIndex:indexPath.row];
    [cell.leftButton setTitle:[arrObject objectAtIndex:0] forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[arrObject objectAtIndex:1]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak myKnotCell *weakCell = cell;
    
    [cell.leftImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.leftImage.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCategoryImages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWDetailScreen *detailScreen=[[WWDetailScreen alloc]initWithNibName:@"WWDetailScreen" bundle:nil];
    NSArray *arrObject=[arrCategoryImages objectAtIndex:indexPath.row];
    detailScreen.vendorList= arrObject;
    
    [self.navigationController pushViewController:detailScreen animated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.navigation popViewControllerAnimated:YES];
}
		

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
