//
//  TPSettingController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/29.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPSettingController.h"


@interface TPSettingController ()

@end

@implementation TPSettingController

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
    QSection *section = [[QSection alloc] init];
    QButtonElement *logoutbtn = [[QButtonElement alloc] initWithKey:@"button"];
    logoutbtn.title = @"ログアウト";
    logoutbtn.controllerAction = @"onLogout";
    
    [self.root addSection:section];

    [section addElement: logoutbtn];
}

- (void)onLogout
{
    [[TPUserInfo sharedInstance] clearUserInfo];
    if(FBSession.activeSession.isOpen){
        [FBSession.activeSession closeAndClearTokenInformation];
        //[FBSession setActiveSession:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TPShowLogin object:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
