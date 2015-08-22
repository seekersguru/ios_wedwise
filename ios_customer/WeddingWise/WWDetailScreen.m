//
//  WWDetailScreen.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/10/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWDetailScreen.h"
#import "WWCategoryCell.h"
#import "WWCategoryDetailVC.h"
#import "WWDashboardVC.h"
#import "NIDropDown.h"


#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0);

@interface WWDetailScreen ()<MBProgressHUDDelegate,UITextFieldDelegate,WWCategoryCellDelegate,NIDropDownDelegate>
{
    NSMutableArray *arrVendorData;
    NSString *filterType;
    NSString *filterTime;
    NSString *filterDate;
    BOOL isFilterViewPrepared;
    NSArray *filterArray;
    NSMutableArray *filterSelectedArray;
    NSString *tempFavorite;
    NSMutableArray *searchArray;
    BOOL searchingResult;
    NSString *locationVersion;
    NIDropDown *dropDown;
    NSString *venueID;
    NSString *priceID;
}

@property (nonatomic, strong) NSMutableArray *venueArray;
@property (nonatomic, strong) NSMutableArray *priceArray;

@property (weak, nonatomic) IBOutlet UIView *dynamicFilterView;

@end

@implementation WWDetailScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    priceID = @"";
    venueID = @"";
    [self.navigationController.navigationBar setHidden:YES];
    
    
    
    arrVendorData=[[NSMutableArray alloc]init];
    _priceArray= [[NSMutableArray alloc]init];
    
    [self callWebService:@"" page:@""];
    [_filterView setHidden:YES];
    
    [self.vendorNameLabel setTitle:self.vendorList[0] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    [_priceRangeButton.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [_venueTypeButton.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    
    [_searchButton.titleLabel setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [_searchTextfield setFont:[UIFont fontWithName:AppFont size:15.0f]];
    [_filterTextfield setFont:[UIFont fontWithName:AppFont size:15.0f]];

    [_lblSearchLocation setHidden:YES];
    [_lblSearchPrice setHidden:YES];
    [_lblSearchVenue setHidden:YES];
    [_lblSearchString setHidden:YES];
    _searchView.hidden= YES;
}

- (void)viewWillAppear:(BOOL)animated{
    //_searchView.frame = CGRectMake(0, _searchView.frame.origin.y, _searchView.frame.size.width, 1);
}
- (IBAction)radioTypeSelection:(UIButton *)sender {
    if (!filterSelectedArray) {
        filterSelectedArray = [NSMutableArray new];
    }
    NSMutableDictionary *filterDict = [NSMutableDictionary new];
    
    for (int i = 0; i < filterArray.count; i++) {
        NSDictionary *dict = filterArray[i];
        for (int j = 0; j < [[dict valueForKey:@"values"] count]; j++) {
            NSString *type = [[dict valueForKey:@"values"] objectAtIndex:j];
            [filterDict setObject:[dict valueForKey:@"name"] forKey:type];
        }
    }
    
    NSString *key1 = [[filterDict allValues] objectAtIndex:sender.tag-1];
    NSString *value1 = [[filterDict allKeys] objectAtIndex:sender.tag-1];
    [filterDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqualToString:key1] && ![key isEqualToString:key1]) {
            NSMutableArray *filterSelectedArrayCopy = [filterSelectedArray copy];
            for (NSDictionary *dict in filterSelectedArrayCopy) {
                if ([[dict allKeys] containsObject:key1]) {
                    [filterSelectedArray removeObjectAtIndex:[[dict allKeys] indexOfObject:key1]];
                }
            }
            
            NSUInteger indexOfObject = [[filterDict allKeys] indexOfObject:key];
            [(UIButton *)[sender.superview viewWithTag:indexOfObject+1] setSelected:NO];
        }
    }];
    [filterSelectedArray addObject:@{key1:value1}];
    sender.selected = YES;
}
- (void)filterVendor:(id)sender{
    [_filterTextfield resignFirstResponder];
    [_tblContryName reloadData];
    [_tblContryName setHidden:YES];
    
    _searchView.frame = CGRectMake(0, 55, self.searchView.frame.size.width, 1);
    [_lblSearchLocation setHidden:YES];
    [_lblSearchPrice setHidden:YES];
    [_lblSearchVenue setHidden:YES];
    [_lblSearchString setHidden:YES];
    
    BOOL isHidden = _filterView.hidden;
    if (_filterView.hidden) {
        [_filterView setHidden:NO];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         if (isHidden) {
                             [self getLocationVersion];
                             _filterView.frame = CGRectMake(0, 58, self.view.frame.size.width, self.view.frame.size.height-60);
                         }
                         else{
                             _filterView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         if (!isHidden) {
                             [_filterView setHidden:YES];
                         }
                     }];
}

- (IBAction)submitFilterAction:(UIButton *)sender {
    [self filterVendor:sender];
    [_filterTextfield resignFirstResponder];
    NSString *searchString = _searchTextfield.text;

    [self callWebService:searchString page:@""];
    [_lblSearchString setText:_searchTextfield.text];
    
    if(_lblSearchLocation.text.length>0 && _lblSearchVenue.text.length>0 && _lblSearchPrice.text && _lblSearchLocation.text){
         [self.vendorNameLabel setTitle:self.vendorList[0] forState:UIControlStateNormal];
    }
    [_vendorNameLabel setTitle:@"Show filter" forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)callWebService:(NSString *)searchString page:(NSString *)minValue{
    if (!searchString) {
        searchString = @"";
    }
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
    
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 self.vendorList[0],@"vendor_type",
                                 @"1",@"page_no",
                                 searchString,@"search_string",
                                 priceID, @"pricing",
                                 venueID,@"venue_type",
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"customer_vendor_list_and_search",@"action",
                                 minValue,@"min",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"%lu", responseDics.count);
         if (!minValue || minValue.length == 0) {
             [arrVendorData removeAllObjects];
         }
         if(responseDics.count>0){
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 if (!isFilterViewPrepared) {
                     filterArray = [[responseDics valueForKey:@"json"] valueForKey:@"filters"];
                 }
                 NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"vendor_list"];
                 if(arrData.count>0){
                     [_lblNoDataFound setHidden:YES];
                     for (NSDictionary *dicVendor in arrData) {
                         [arrVendorData addObject:dicVendor];
                     }
                 }
                 else{
                     
                     [_lblNoDataFound setHidden:NO];
                     [_lblNoDataFound setFont:[UIFont fontWithName:AppFont size:17.0]];
                 }
                 
                 _priceArray= responseDics[@"json"][@"pricing"][@"value"];
                 _venueArray= responseDics[@"json"][@"venue_type"][@"value"];
                 
                 NSLog(@"%@", [_venueArray objectAtIndex:0]);
                 
                 if(_priceRangeButton.titleLabel.text.length==0){
                     //[_priceRangeButton setTitle:responseDics[@"json"][@"pricing"][@"name"] forState:UIControlStateNormal];
                     [_priceRangeButton setTitle:[[_priceArray objectAtIndex:0] objectAtIndex:1] forState:UIControlStateNormal];
                 }
                 
                 if (_venueTypeButton.titleLabel.text.length==0){
                     //[_venueTypeButton setTitle:responseDics[@"json"][@"venue_type"][@"name"] forState:UIControlStateNormal];
                     [_venueTypeButton setTitle:[[_venueArray objectAtIndex:0]  objectAtIndex:1]  forState:UIControlStateNormal];
                 }
             }
             
         }
         else{
             [[WWCommon getSharedObject]createAlertView:kAppName :@"No data found." :nil :000 ];
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [_tblCategory reloadData];
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

- (void)prepareDynamicFilterView:(NSArray *)filterArray{
    int index = 1;
    int x1 = 20, x2 = 158, y = 66;
    for (NSDictionary *dict in filterArray) {
        NSString *buttonType = [dict valueForKey:@"type"];
        int index1 = 1;
        for (NSString *type in [dict valueForKey:@"values"]) {
            CGRect buttonFrame;
            buttonFrame.size.width = 25;
            buttonFrame.size.height = 25;
            buttonFrame.origin.y = y;
            if (index % 2 != 0) {
                buttonFrame.origin.x = x1;
            }
            else{
                buttonFrame.origin.x = x2;
                if (index1 != [[dict valueForKey:@"values"] count]) {
                    y+=28;
                }
            }
            UIButton *checkBox = [[UIButton alloc] initWithFrame:buttonFrame];
            checkBox.tag = index;
            [checkBox setTitle:buttonType forState:UIControlStateNormal];
            if ([buttonType isEqualToString:@"radio"]) {
                [checkBox setImage:[UIImage imageNamed:@"radiobt"] forState:UIControlStateNormal];
                [checkBox setImage:[UIImage imageNamed:@"radiobtMark"] forState:UIControlStateSelected];
                [checkBox addTarget:self action:@selector(radioTypeSelection:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [checkBox setImage:[UIImage imageNamed:@"checkbt"] forState:UIControlStateNormal];
                [checkBox setImage:[UIImage imageNamed:@"checkbtMark"] forState:UIControlStateSelected];
                [checkBox addTarget:self action:@selector(checkTypeSelection:) forControlEvents:UIControlEventTouchUpInside];
            }
            buttonFrame.origin.x += 25;
            buttonFrame.origin.y += 6;
            buttonFrame.size.width = 76;
            UILabel *label = [[UILabel alloc] initWithFrame:buttonFrame];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setText:type];
            [label setFont:[UIFont systemFontOfSize:10]];
            [label setNumberOfLines:0];
            [label sizeToFit];
            
            [_dynamicFilterView addSubview:checkBox];
            [_dynamicFilterView addSubview:label];
            index++;
            index1++;
        }
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(10, y+28, 262, 1)];
        [seperatorView setBackgroundColor:[UIColor lightGrayColor]];
        [_dynamicFilterView addSubview:seperatorView];
        y+=33;
    }
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(76, y+3, 131, 25)];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor colorWithRed:240/255.0 green:105/255.0 blue:89/255.0 alpha:1.0]];
    [submitButton addTarget:self action:@selector(submitFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dynamicFilterView addSubview:submitButton];
    
    CGRect frame = _dynamicFilterView.frame;
    frame.size.height = submitButton.frame.origin.y + 35;
    [_dynamicFilterView setFrame:frame];
}
-(IBAction)venueTypeClicked:(id)sender{
    NSArray * arr = [[NSArray alloc] init];
    arr = _venueArray;
    
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
-(IBAction)pricechangedClicked:(id)sender{
    NSArray * arr = [[NSArray alloc] init];
    arr = _priceArray;
    
    if(dropDown == nil) {
        CGFloat f = 100;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}


- (void) niDropDownDelegateMethod: (NIDropDown *) sender withRow:(NSInteger)row withButtonTag:(NSInteger)buttonTag{
    if(buttonTag==1){
        venueID = [[_venueArray objectAtIndex:buttonTag] objectAtIndex:0];
        [_lblSearchLocation setText:[[_venueArray objectAtIndex:buttonTag] objectAtIndex:1]];
        
        
    }
    else if (buttonTag == 2){
        priceID = [[_priceArray objectAtIndex:buttonTag] objectAtIndex:0];
        [_lblSearchPrice setText:[[_priceArray objectAtIndex:buttonTag] objectAtIndex:1]];
    }
    
    [self rel];
}


-(void)niSelectValue:(id)sender{
    
}
-(void)rel{
    dropDown = nil;
}
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

-(IBAction)titleClicked:(id)sender{
    
    if(_lblSearchLocation.text.length>0 || _lblSearchVenue.text.length>0){
        
        BOOL isHidden = _searchView.hidden;
        if (_searchView.hidden) {
            [_searchView setHidden:NO];
        }
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             if (isHidden) {
                                 _searchView.frame = CGRectMake(0, 55, self.searchView.frame.size.width, 83);
                                 _imgDropdown.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(360));
                                 [_lblSearchLocation setHidden:NO];
                                 [_lblSearchPrice setHidden:NO];
                                 [_lblSearchVenue setHidden:NO];
                                 [_lblSearchString setHidden:NO];
                                 [_vendorNameLabel setTitle:@"Hide filter" forState:UIControlStateNormal];
                             }
                             else{
                                 _imgDropdown.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(180));
                                 _searchView.frame = CGRectMake(0, 55, self.searchView.frame.size.width, 1);
                                 [_lblSearchLocation setHidden:YES];
                                 [_lblSearchPrice setHidden:YES];
                                 [_lblSearchVenue setHidden:YES];
                                 [_lblSearchString setHidden:YES];
                                 [_vendorNameLabel setTitle:@"Show filter" forState:UIControlStateNormal];
                             }
                         }
                         completion:^(BOOL finished){
                             if (!isHidden) {
                                 [_searchView setHidden:YES];
                             }
                         }];
    }
    
    
    
    
    
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_tblCategory){
        
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
//        self.tblCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
//        if ((indexPath.row == [arrVendorData count] - 1))
//        {
//            [self callWebService:@"" page:dicVendorData[@"vendor_email"]];
//        }
        return cell;
    }
    else if (tableView == _tblContryName){
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        if(searchingResult){
            cell.textLabel.text = [searchArray objectAtIndex:indexPath.row];
        }
        else{
            cell.textLabel.text = [[AppDelegate sharedAppDelegate].arrCountryList objectAtIndex:indexPath.row];
        }
        [cell.textLabel setFont:[UIFont fontWithName:AppFont size:17.0]];
        [cell setBackgroundColor:[UIColor darkGrayColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView== _tblContryName){
        return 35.0;
    }
    else{
        return 185.0f;
    }
    return 0.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView== _tblContryName){
        if(searchingResult)
            return searchArray.count;
        else
            return [AppDelegate sharedAppDelegate].arrCountryList.count;
        
    }
    else
        return arrVendorData.count;
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _tblCategory){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        WWCategoryDetailVC *detailScreen=[[WWCategoryDetailVC alloc]initWithNibName:@"WWCategoryDetailVC" bundle:nil];
        detailScreen.hidesBottomBarWhenPushed = YES;
        detailScreen.vendorEmail=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"vendor_email"];
        detailScreen.vendorName=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"name"];
        [self.navigationController pushViewController:detailScreen animated:YES];
        detailScreen.hidesBottomBarWhenPushed = NO;
    }
    else{
        _filterTextfield.text= [searchArray objectAtIndex:indexPath.row];
        [_tblContryName setHidden:YES];
        [_lblSearchVenue setText:[searchArray objectAtIndex:indexPath.row]];
    }
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark: favoriteDelegate methods


-(void)addFavorites:(id)sender{
    tempFavorite = @"";
    NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"EmailID"];
    if(savedGroomName.length>0){
        NSDictionary *dicVendorData=[arrVendorData objectAtIndex:[sender tag]];
        if([dicVendorData[@"favorite"] isEqualToString:@"-1"]){
            //[dicVendorData setValue:@"1" forKey:@"favorite"];
            tempFavorite=@"1";
        }
        else if ([dicVendorData[@"favorite"] isEqualToString:@"1"]){
            //[dicVendorData setValue:@"-1" forKey:@"favorite"];
            tempFavorite=@"-1";
        }
        // [_tblCategory reloadData];
        
        
        
        [self callFavoriteApi:dicVendorData withFavorite:tempFavorite];
    }
    else{
        [AppDelegate sharedAppDelegate].isLogOut= YES;
        
        
        WWDashboardVC *dash=[[WWDashboardVC alloc]initWithNibName:@"WWDashboardVC" bundle:nil];
        dash.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dash animated:YES];
    }
}
-(void)callFavoriteApi:(NSDictionary*)dicVendor withFavorite:(NSString*)isFavorite{
    
    NSDictionary *dicParameters= [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"identifier"],@"identifier",
                                  dicVendor[@"vendor_email"],@"vendor_email",
                                  isFavorite,@"favorite",
                                  @"add_favorite",@"action",nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:dicParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"responseDics :%@",responseDics);
         [self callWebService:@"" page:@""];
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark UITextfield delegate methods:
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if(textField == _filterTextfield){
        if (string.length>0) {
            [_tblContryName setHidden:NO];
        }
        
        NSString *searchTerm = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self updateAsPerSearchTerm: searchTerm];
    }
    return YES;

}
-(void)updateAsPerSearchTerm:(NSString *)searchTerm
{
    if(searchTerm.length==0){
        [_tblContryName setHidden:YES];
    }
    else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchTerm];
        searchArray = (NSMutableArray*)[[AppDelegate sharedAppDelegate].arrCountryList filteredArrayUsingPredicate:predicate];
        searchingResult= YES;
        [_tblContryName reloadData];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(void)callLocationListAPI{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"",@"match_string",
                                 @"locations",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [AppDelegate sharedAppDelegate].arrCountryList = [[NSMutableArray alloc] init];
             
             for (NSString *countryName in responseDics[@"json" ][@"locations"]) {
                 [[AppDelegate sharedAppDelegate].arrCountryList addObject:countryName];
             }
             
             [[NSUserDefaults standardUserDefaults]setObject:responseDics[@"json"][@"version"] forKey:@"version"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [_tblContryName reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
    
}
-(void)getLocationVersion{
    
    NSString *version = nil;
    NSString *vearsionValue= [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"version"];
    if(vearsionValue.length>0){
       version=[[NSUserDefaults standardUserDefaults]
                           stringForKey:@"version"];
    }
    else
        version=@"1";
    
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES]setLabelText:@""];
    
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1", @"current_version",
                                 @"get_locations_version",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             locationVersion = [NSString stringWithFormat:@"%@",responseDics[@"json"][@"version"]];
             NSString *versionValue= [[NSUserDefaults standardUserDefaults]
                                      stringForKey:@"version"];
             
             //if(![versionValue isEqualToString:locationVersion]){
                 [self callLocationListAPI];
             //}
         }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }
        failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
