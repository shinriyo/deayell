//
//  TPMyPageController.m
//  travelphoto
//
//  Created by Yuuna Morisawa on 2013/06/29.
//  Copyright (c) 2013年 Yuuna Kurita. All rights reserved.
//

#import "TPMyPageController.h"

@interface TPMyPageController ()

@end

@implementation TPMyPageController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // TODO:作る
    QSection *section = [[QSection alloc] initWithTitle:@"TODO"];
    QEntryElement *email = [[QEntryElement alloc] initWithKey:@"email"];
    email.keyboardType = UIKeyboardTypeEmailAddress;
    email.bind = @"textValue:email";
    //email.title = NSLocalizedString(@"HOGE", nil);
    email.title = @"テスト";

    [self.root addSection:section];
    [section addElement: email];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
