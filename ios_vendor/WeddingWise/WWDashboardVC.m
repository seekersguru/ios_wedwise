//
//  WWLoginVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWDashboardVC.h"
#import "WWLoginVC.h"
#import "WWRegistrationVC.h"
#import "FacebookManager.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface WWDashboardVC ()

@end


@implementation WWDashboardVC


- (void)viewDidLoad {
    
    [[WWCommon getSharedObject]setCustomFont:14.0 withLabel:lblPolicy withText:lblPolicy.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnLogin withText:_btnLogin.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnSignUp withText:_btnSignUp.titleLabel.text];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(callBackGroundImageWebService) withObject:nil afterDelay:0.1];
    //    [self callBackGroundImageWebService];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDataService:)
                                                 name:@"getDataformFb" object:nil];
}

-(void)callBackGroundImageWebService{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 @"customer_bg_image_login_registration",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arr=[[responseDics valueForKey:@"json"] valueForKey:@"data"];
             
             
             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",[arr objectAtIndex:0]]];
             NSURLRequest *request = [NSURLRequest requestWithURL:url];
             UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
             
//             [_bgImage setImageWithURLRequest:request
//                             placeholderImage:placeholderImage
//                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                          _bgImage.image = image;
//                                      } failure:nil];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(void)getDataService:(NSNotification*) notification{
    
    NSLog(@"Notifications: %@", notification);
    NSDictionary *dict = [[notification object] mutableCopy];
    
    [self FBAuthentication:dict];
}
-(void)FBAuthentication:(NSDictionary*)fbResponse{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [fbResponse valueForKey:@"email"],@"email",
                                 @"vendor_registration_login_fb_gm",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSString *result=[responseDics valueForKey:@"result"];
         if([result isEqualToString:@"error"]){
             //Send to reegistration
             WWRegistrationVC *registrationVC=[[WWRegistrationVC alloc]initWithNibName:@"WWRegistrationVC" bundle:nil];
             registrationVC.fbResponse= fbResponse;
             //registrationVC.bgImage.image= _bgImage.image;
             registrationVC.image= _bgImage.image;
             [self.navigationController pushViewController:registrationVC animated:YES];
         }
         else if ([result isEqualToString:@"success"]){
             //Login successfully
             dispatch_async(dispatch_get_main_queue(), ^{
                 UITabBarController *tabVC = [[AppDelegate sharedAppDelegate]setupViewControllers:nil];
                 [self.navigationController pushViewController:tabVC animated:YES];
             });
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                    } else {
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                    }
                }];
        
    }
}
-(IBAction)googleSignIn:(id)sender{
    [self signInGoogle];
}
-(void)signInGoogle{
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kGPClientID;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];
    
}
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}
-(IBAction)btnLoginPressed:(id)sender{
    WWLoginVC *loginVC=[[WWLoginVC alloc]initWithNibName:@"WWLoginVC" bundle:nil];
    loginVC.image= _bgImage.image;
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(IBAction)btnRegistrationPressed:(id)sender{
    WWRegistrationVC *registrationVC=[[WWRegistrationVC alloc]initWithNibName:@"WWRegistrationVC" bundle:nil];
    registrationVC.image= _bgImage.image;
    [self.navigationController pushViewController:registrationVC animated:YES];
}
-(IBAction)btnShowMorePressed:(id)sender{
    
}
-(IBAction)btnFBLoginPressed:(id)sender{
    [[FacebookManager sharedManager]callFaceBookLogin:^(NSDictionary *loginResponse) {
        NSLog(@"Responce: %@", loginResponse);
        [self getFaceBookEmailID:loginResponse loadThreadWithCompletion:^(NSDictionary *response) {
            
        } failure:^(NSString *failureResponse) {
            
        }];
        
    } failure:^(NSString *failureResponse) {
        
    }];
}
-(void)getFaceBookEmailID:(NSDictionary*)loginResponse loadThreadWithCompletion:(void(^)(NSDictionary * response))cmpl failure:(void(^)(NSString *failureResponse))failure{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=email" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSMutableDictionary* user, NSError *error) {
         if (!error) {
             NSLog(@"getFaceBookCoverPic: %@",user);
             [self FBAuthentication:user];
         }
     }];
}
-(IBAction)btnGooglePressed:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
