//
//  TPLoginController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPLoginController.h"
#import "SVModalWebViewController.h"

@interface TPLoginController ()

@end

@implementation TPLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//}

//- (void)viewDidAppear:(BOOL)animated
//{
	// Do any additional setup after loading the view.
    self.root.title = NSLocalizedString(@"TPLoginControllerLoginForm", nil);
    
    
    QSection *section = [[QSection alloc] init];
    QEntryElement *email = [[QEntryElement alloc] initWithKey:@"email"];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.placeholder = NSLocalizedString(@"TPLoginControllerEmailMsg", nil);
    email.bind = @"textValue:email";
    email.title = @"Email";
    
    QEntryElement *password = [[QEntryElement alloc] initWithKey:@"password"];
    password.placeholder = NSLocalizedString(@"TPLoginControllerPasswordMsg", nil);
    password.bind = @"textValue:password";
    password.secureTextEntry = TRUE;
    password.title = @"Password";
    
    
    [self.root addSection:section];
    [section addElement: email];
    [section addElement: password];
    
    QSection *section2 = [[QSection alloc] init];
    QButtonElement *loginbtn = [[QButtonElement alloc] initWithKey:@"button"];
    loginbtn.title = NSLocalizedString(@"TPLoginControllerLogin", nil);
    loginbtn.controllerAction = @"onLogin";
    
    [self.root addSection:section2];
    [section2 addElement: loginbtn];
    

    QSection *section3 = [[QSection alloc] init];
    QButtonElement *newbtn = [[QButtonElement alloc] initWithKey:@"button"];
    newbtn.title = NSLocalizedString(@"TPLoginControllerNewRegister", nil);
    newbtn.controllerAction = @"onRegister";
    
    [self.root addSection:section3];
    [section3 addElement: newbtn];
    
    
    QSection *section4 = [[QSection alloc] init];
    QButtonElement *passwordbtn = [[QButtonElement alloc] initWithKey:@"button"];
    passwordbtn.title = NSLocalizedString(@"TPLoginControllerResendPass", nil);
    passwordbtn.controllerAction = @"onSendPassword";
    
    [self.root addSection:section4];
    [section4 addElement: passwordbtn];
    
    
    QSection *section5 = [[QSection alloc] init];
    QButtonElement *facebookbtn = [[QButtonElement alloc] initWithKey:@"button"];
    facebookbtn.title = NSLocalizedString(@"TPLoginControllerFacebookRegister", nil);
    facebookbtn.controllerAction = @"onFacebookLogin";
    
    [self.root addSection:section5];
    [section5 addElement: facebookbtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestFromFacebook) name:TPLoginFacebook object:nil];
}

- (void)onFacebookLogin{
    [[TPFacebook sharedInstance] openFacebook:TPLoginFacebook];
}

- (void)requestFromFacebook{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        [self onRegisterFacebook :result[@"email"] uid:result[@"id"] username:result[@"name"]];
        
    }];
}

- (void)onRegisterFacebook:(NSString *)email uid:(NSString *)uid username:(NSString *)username
{
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    
    if([tp_api.networkStatus boolValue] == NO){
        return;
    }
    
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    
    
    NSDictionary *userDic = @{@"email": email ,
                              @"uid": uid,
                              @"username": username};
    
    NSString *path = [tp_api signInFacebookPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         
                                         JSONRequestOperationWithRequest:[sharedClient requestWithMethod:@"POST"
                                                                                                    path: path
                                                                                              parameters: userDic
                                                                          
                                                                          ]
                                         
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             
                                             TPUserInfo *sharedInstance = [TPUserInfo sharedInstance];
                                             [sharedInstance savePassword: nil];
                                             [sharedInstance saveEmail:[JSON objectForKey:@"email"]];
                                             [sharedInstance saveAuthToken:[JSON objectForKey:@"auth_token"]];
                                             
                                             [SVProgressHUD dismiss];
                                             NSDictionary *dic = @{@"CLASS": @"TPMyPageController"};
                                             [[NSNotificationCenter defaultCenter] postNotificationName:TPShowPanel object:self userInfo:dic];
                                             
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                             
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             
                                             
                                             [SVProgressHUD dismiss];
                                             
                                             
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSendPassword
{
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:[tp_api sendPasswordUrl]];
    [self presentViewController:webViewController animated:YES completion:nil];
}

- (void)onRegister
{
    // 登録画面に移動
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    TPRegisterController *viewController = (TPRegisterController *) [[TPRegisterController alloc] initWithRoot:root];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onLogin
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"TPLoginControllerSending", nil) maskType:SVProgressHUDMaskTypeBlack];
    // フォーム取得
    QEntryElement *email = (QEntryElement *)[self.root elementWithKey:@"email"];
    QEntryElement *password = (QEntryElement *)[self.root elementWithKey:@"password"];
    
    
    if(email.textValue == NULL || password.textValue == NULL){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TPLoginControllerSending", nil)];
        return;
    }
    
    // 通信処理
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    
    if([tp_api.networkStatus boolValue] == NO){
        return;
    }

    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];

    
    NSDictionary *userDic = @{@"user[email]": email.textValue ,
                              @"user[password]": password.textValue};
    
    NSString *path = [tp_api signInPath];
    
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                        
                                         JSONRequestOperationWithRequest:[sharedClient requestWithMethod:@"POST"
                                                                                                    path: path
                                                                                              parameters: userDic
                                                                          
                                                                          ]

                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                            
                                             TPUserInfo *sharedInstance = [TPUserInfo sharedInstance];
                                             [sharedInstance savePassword:password.textValue];
                                             [sharedInstance saveEmail:[JSON objectForKey:@"email"]];
                                             [sharedInstance saveAuthToken:[JSON objectForKey:@"auth_token"]];
                                    
                                             [SVProgressHUD dismiss];
                                             NSDictionary *dic = @{@"CLASS": @"TPMyPageController"};
                                             [[NSNotificationCenter defaultCenter] postNotificationName:TPShowPanel object:self userInfo:dic];
                                             
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                             
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Error: %@", error);
                                             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TPLoginControllerErrorHappened", nil) message:NSLocalizedString(@"TPLoginControllerEmailErrorHappened", nil)
                                                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"TPLoginControllerConfirm", nil) otherButtonTitles:nil];
                                             
                                             [alertView show];

                                             
                                             [SVProgressHUD dismiss];
                                             
                                            
                                         }];
    [sharedClient enqueueHTTPRequestOperation:operation];
}

@end
