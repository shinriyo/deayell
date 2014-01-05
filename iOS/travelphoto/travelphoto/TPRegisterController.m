//
//  TPRegisterController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPRegisterController.h"

@interface TPRegisterController ()

@end

@implementation TPRegisterController

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
	// Do any additional setup after loading the view.
    UIBarButtonItem *submitButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"TPRegisterControllerRegister", nil)
        style:UIBarButtonItemStyleDone
        target:self action:@selector(onSubmit)];

    [self.navigationItem setRightBarButtonItem:submitButtonItem];

    self.root.title = NSLocalizedString(@"TPRegisterControllerNewMemberRegister", nil);
    
    QSection *section2 = [[QSection alloc] initWithTitle:NSLocalizedString(@"TPRegisterControllerLoginInfo", nil)];
    QEntryElement *email = [[QEntryElement alloc] initWithKey:@"email"];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.bind = @"textValue:email";
    email.title = NSLocalizedString(@"TPRegisterControllerEmail", nil);

    QEntryElement *username = [[QEntryElement alloc] initWithKey:@"username"];
    username.keyboardType = UIKeyboardAppearanceDefault;
    username.bind = @"textValue:username";
    username.title = NSLocalizedString(@"TPRegisterControllerUserName", nil);
    
    QEntryElement *password = [[QEntryElement alloc] initWithKey:@"password"];
    password.bind = @"textValue:password";
    password.secureTextEntry = TRUE;
    password.title = NSLocalizedString(@"TPRegisterControllerPassword", nil);

    QEntryElement *password_confirm = [[QEntryElement alloc] initWithKey:@"password_confirm"];
    password_confirm.bind = @"textValue:password";
    password_confirm.secureTextEntry = TRUE;
    password_confirm.title = NSLocalizedString(@"TPRegisterControllerPasswordConfirm", nil);

    [self.root addSection:section2];
    [section2 addElement: email];
    [section2 addElement: username];
    [section2 addElement: password];
    [section2 addElement: password_confirm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 抜けてた
- (void)onSubmit
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"TPRegisterControllerSending", nil) maskType:SVProgressHUDMaskTypeBlack];
    // フォーム取得
    QEntryElement *email = (QEntryElement *)[self.root elementWithKey:@"email"];
    QEntryElement *password = (QEntryElement *)[self.root elementWithKey:@"password"];
    QEntryElement *password_confirm = (QEntryElement *)[self.root elementWithKey:@"password_confirm"];
    QEntryElement *username = (QEntryElement *)[self.root elementWithKey:@"username"];
    
    if(email.textValue == NULL || password.textValue == NULL || password_confirm.textValue == NULL || username.textValue == NULL ) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CommonNoFormData", nil)];
        return;
    }

    // 通信処理
    TravelPhotoAPI *tp_api = [TravelPhotoAPI sharedInstance];
    
    if([tp_api.networkStatus boolValue] == NO){
        return;
    }
    
    AFHTTPClient *sharedClient = [TravelPhotoAPI sharedClient];
    
    // 投稿用の値
    NSDictionary *userDic = @{@"user[email]": email.textValue,
                              @"user[password]": password.textValue,
//                              @"user[password_confirm]": password_confirm.textValue,
                              @"user[password_confirmation]": password_confirm.textValue,
                              @"user[username]": username.textValue};

    NSString *path = [tp_api signUpPath];
    NSLog(@"%@",path);
    [sharedClient setParameterEncoding:AFFormURLParameterEncoding];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:[sharedClient requestWithMethod:@"POST"
                                                                          path: path
                                                                          parameters: userDic]
                                         
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response,id JSON) {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:TPReloadTravels object:self userInfo:nil];
                                             
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                             
                                             [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CommonCreateDone", nil)];
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             //NSLog(@"Error: %@", error);
                                             NSLog(@"Error: %@", [error localizedRecoverySuggestion]);
                                             
                                             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"TPRegisterControllerErrorHappened", nil) message:NSLocalizedString(@"TPRegisterControllerEmailErrorHappened", nil)
                                                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"CommonConfirm", nil) otherButtonTitles:nil];
                                             [alertView show];
                                             [SVProgressHUD dismiss];
                                         }];

    [sharedClient enqueueHTTPRequestOperation:operation];
}

@end
