//
//  TPRegistController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/30.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPRegistController.h"

@interface TPRegistController ()

@end

@implementation TPRegistController

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
    UIBarButtonItem *submitButtonItem =    [[UIBarButtonItem alloc] initWithTitle:@"登録"
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self action:@selector(onSubmit)];
    [self.navigationItem setRightBarButtonItem:submitButtonItem];
    
    
        
    self.root.title = @"新規会員登録";
    
    QSection *section2 = [[QSection alloc] initWithTitle:@"ログイン情報"];
    QEntryElement *email = [[QEntryElement alloc] initWithKey:@"email"];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.bind = @"textValue:email";
    email.title = @"メールアドレス";
    
    QEntryElement *username = [[QEntryElement alloc] initWithKey:@"username"];
    username.keyboardType = UIKeyboardAppearanceDefault;
    username.bind = @"textValue:username";
    username.title = @"ユーザー名";
    
    
    QEntryElement *password = [[QEntryElement alloc] initWithKey:@"password"];
    password.bind = @"textValue:password";
    password.secureTextEntry = TRUE;
    password.title = @"パスワード";
    
    QEntryElement *password_confirm = [[QEntryElement alloc] initWithKey:@"password_confirm"];
    password_confirm.bind = @"textValue:password";
    password_confirm.secureTextEntry = TRUE;
    password_confirm.title = @"パスワード（確認）";
    

    
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

@end
